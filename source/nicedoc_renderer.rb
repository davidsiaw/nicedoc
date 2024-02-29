require 'active_support/inflector'

class NicedocRenderer
  def initialize(contents, filename, yaml, debug: false)
    @contents = contents
    @yaml = yaml
    @filename = filename
    @debug = debug
  end

  def dirname
    @filename.split('/')[0..-2].join('/')
  end

  def theme
    @yaml['theme'] || "indigo"
  end

  def pagetype
    @yaml['type'] || 'manual'
  end

  def generate(path, context)
    rcontext = self
    yaml = @yaml
    theme = self.theme
    filename = @filename

    context.empty_page path, "#{yaml['title'] || "_"}" do
      request_css "css/#{theme}.css"
      rcontext.generate_contents(self)
    end
  end

  def generator_class_name
    "#{pagetype.camelize}PageGenerator"
  end

  def generator_class
    return DebugPageGenerator if @debug

    Kernel.const_get(generator_class_name)
  end

  def generate_contents(context)
    cg = generator_class.new(context, @contents, @yaml, @filename)
    cg.generate!
  end
end

class DebugPageGenerator < ContentGenerator
  def generate!
    sections.each do |s|
      display_debug(@context, s)
    end
  end

  def display_debug(context, section)
    sect = section
    blocks = section.blocks
    cxt = self
    context.row do
      col 12 do
        pre do
          text "section\n"
          text "type: #{sect.type}\n"
          text "headerlevel: #{sect.headerlevel}\n"
          text "listlevel: #{sect.listlevel}\n"
          text "blocks #{blocks.length}\n"
        end

        blockquote do
          ol do
            blocks.each do |block|
              li do
                pre do
                  text "block\n"
                  text "tag: #{block.tag}\n"
                  text "type: #{block.type}\n"
                  text "level: #{block.level}\n"
                  text "lines: #{block.lines.count}\n"
                  text "info: #{block.info.to_yaml}\n"
                  block.lines.each do |line|
                    text "> #{line}\n"
                  end
                end
              end
            end
          end
          
          #{blocks.map{|b| b.lines.inspect}.join('|')}"
          sect.children.each do |s|
            cxt.display_debug(self, s)
          end
        end
      end
    end
  end
end

class SectionHandler
  def handle(section, context)
    false
  end
end


class HeaderSectionHandler < SectionHandler
  def handle(section, context)
    return false unless section.type == :header 

    context.send(:"h#{section.headerlevel}", section.blocks.first.lines.first)
    true
  end
end

class ParaSectionHandler < SectionHandler
  def block_handler_list
    [
      ListBlockHandler.new,
      SingleBlockHandler.new,
      ExplicitBlockHandler.new,
      ImplicitBlockHandler.new,
      BreakBlockHandler.new,
      EmptyBlockHandler.new
    ]
  end

  def handle(section, context)
    return false unless section.type == :para 

    handlerstate = {}
    section.blocks.each do |block|

      consumed_by_handler = false
      block_handler_list.each do |bh|
        handled = bh.handle(block, handlerstate, context)

        if handled
          consumed_by_handler = true
          break
        end
      end
      raise "unconsumed block: #{block.type.inspect}" unless consumed_by_handler

      # block.lines.each do |line|
      #   context.div line
      # end
    end
    true
  end
end


class BlockHandler
  def handle(block, handlerstate, context)
    false
  end
end

class EmptyBlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :empty

    true
  end
end

class BreakBlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :break

    context.br

    true
  end
end

class ImplicitBlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :implicit

    block.lines.each do |line|
      context.div "#{line}\n"
    end

    true
  end
end


class ExplicitBlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :explicit

    context.pre do
      text block.lines.length.to_s
      block.lines.each do |line|
        text "#{line}\n"
      end
    end

    true
  end
end

class ListBlockHandler
  def counter
    @counter ||= 0

    @counter += 1
  end

  def handle(block, handlerstate, context)
    return false unless block.type == :list

    block.info[:tags].each do |tag|
      next unless tag[:parent].nil?

      write_list(block.info, tag, context)
    end

    true
  end

  def write_list(info, tag, context)
    this = self
    context.send(tag[:tag]) do

      tag[:children].each do |child_idx|
        child = info[:tags][child_idx]

        if child[:type] == :branch
          this.write_list(info, child, self)
        else
          li child[:text]
        end

      end

    end
  end

end


class SingleBlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :single

    true
  end
end


class BlogPageGenerator < ContentGenerator
  def section_handler_list
    [
      HeaderSectionHandler.new,
      ParaSectionHandler.new
    ]
  end

  def generate!
    this = self
    flatlist.each do |s|

      @context.row do
        col 12 do
          div class: 'blog_style' do

            consumed_by_handler = false
            this.section_handler_list.each do |sh|
              handled = sh.handle(s, self)

              if handled
                consumed_by_handler = true
                break
              end
            end
            raise "unconsumed section: #{s.type.inspect}" unless consumed_by_handler

          end
        end
      end

    end
  end
end

class FlatSectionList
  attr_reader :sections

  def initialize(sections)
    @sections = sections
  end

  def flatlist
    @flatlist ||= begin
      list = []
      sections.each do |s|
        insert_into_flatlist(list, s)
      end
      list
    end
  end

  def insert_into_flatlist(list, s)
    list << s

    s.children.each do |child|
      insert_into_flatlist(list, child)
    end
  end
end
