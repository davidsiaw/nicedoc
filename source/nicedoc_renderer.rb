require 'active_support/inflector'

class NicedocRenderer
  def initialize(contents, filename, yaml)
    @contents = contents
    @yaml = yaml
    @filename = filename
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

  def generate_contents(context)
    generator_class_name = "#{pagetype.camelize}PageGenerator"
    genclass = Kernel.const_get(generator_class_name)
    
    cg = genclass.new(context, @contents, @yaml, @filename)
    cg.generate!
  end
end



class ContentGenerator
  attr_accessor :contents, :yaml, :filename

  def initialize(context, contents, yaml, filename)
    @context = context
    @contents = contents
    @yaml = yaml
    @filename = filename
  end

  def lines
    @lines ||= @contents.split("\n")
  end

  def blocks
    Blockifier.new(lines).blocks
  end

  def sections
    Sectionifier.new(blocks).sections
  end

  def generate!
    @context.text "empty content generator"
  end
end

# Sectionifier
# turns blocks into semantic sections
class Sectionifier
  def initialize(blocks)
    @blocks = blocks
  end

  # return remaining blocks
  def consume_block(blocks, cursection)
    loop do
      curblock = blocks.first
      break if curblock.nil?

      # determine the current section type
      if cursection.type.nil?
        if curblock.tag == :ol || curblock.tag == :ul
          cursection.type = curblock.tag
          cursection.listlevel = curblock.level
          next

        elsif curblock.type == :implicit
          cursection.type = :para

        elsif curblock.type == :header
          cursection.type = :header
          cursection.headerlevel = curblock.level

          # pull in the header
          cursection.blocks << curblock
          blocks.shift

          # continue with the rest
          inner = Section.new
          blocks = consume_block(blocks, inner)
          cursection.children << inner
          next

        else
          raise "unknown block type #{curblock.type}"
        end

      elsif cursection.type == :ol || cursection.type == :ul
        break if curblock.tag != cursection.type
        break if curblock.level < cursection.listlevel
        
        if curblock.level > cursection.listlevel
          inner = Section.new
          blocks = consume_block(blocks, inner)
          cursection.children.last.children << inner
          next

        else
          # equal
          inner = Section.new
          inner.type = :li

          # pull in the header
          inner.blocks << blocks.shift
          cursection.children << inner
          next
        end

      else
        if curblock.type == :header
          if cursection.type == :header && curblock.level > cursection.headerlevel
            inner = Section.new
            blocks = consume_block(blocks, inner)
            cursection.children << inner
            next
          end
          break
        end

      end

      cursection.blocks << curblock

      blocks.shift
    end

    blocks
  end

  def sections
    @sections ||= begin
      result = []
  
      remaining = @blocks.dup
  
      remaining.length.times do
        cursection = Section.new
        remaining = consume_block(remaining, cursection)
        result << cursection
        break if remaining.length.zero?
      end
      
      result
    end
  end
end

class Section
  attr_accessor :blocks, :children, :type, :headerlevel, :listlevel

  def initialize
    @blocks = []
    @children = []
    @headerlevel = 0
    @listlevel = 0
  end

  def display(context)
    blocks = @blocks
    context.col 12 do
      text "section #{blocks.length} #{blocks.map{|b| b.lines.inspect}.join('|')}"
    end
  end
end

# Blockifier
# turns lines to blocks
# block types
# - single line "# " "- " "  - " "> " "> > "
# - header block "----", "===="
# - explicit block "```"
# - implicit block
class Blockifier
  attr_reader :lines
  def initialize(lines)
    @lines = lines
  end

  SINGLE_LINE_BLOCKS = {
    header: {
      regex: %r{^(?<level>\#{1,3}) (?<text>.+)}
    },
    ul: {
      regex: %r{^(?<level> *)- (?<text>.+)}
    },
    ol: {
      regex: %r{^(?<level> *)[0-9]+\. (?<text>.+)}
    },

  }

  def single_block_type(line)
    SINGLE_LINE_BLOCKS.each do |typ, info|
      m = info[:regex].match(line)
      next if m.nil?

      return {
        type: typ,
        tag: typ,
        level: m[:level].length,
        text: m[:text]
      }
    end

    nil
  end

  def blocks
    blocks = []

    curblock = Block.new
    lastline = nil

    lines.each do |line|
      sbt = single_block_type(line)

      if curblock.type == :explicit
        if line.start_with?('```')
          blocks << curblock

          curblock = Block.new

        else
          curblock.lines << line
        end
        next
      end

      if curblock.lines.length == 0 && !sbt.nil?
        a = Block.new
        a.lines << sbt[:text]
        a.type = :single
        a.tag = sbt[:tag].to_sym
        a.level = sbt[:level]

        blocks << a
        next
      end

      if curblock.type == :implicit

        lindent = 0
        if line.start_with?(' ' * 4)
          lindent = 1
        end
          
        if line.start_with?('```')
          if curblock.lines.length != 0
            blocks << curblock
          end
          curblock = Block.new
          curblock.type = :explicit
          curblock.tag = :pre
          next

        # underline for header
        elsif curblock.lines.length == 1 &&
              (line.start_with?('--') || line.start_with?('==')) &&
              line.length >= curblock.lines[0].length

          if line.start_with?('==')
            curblock.level = 1
          else
            curblock.level = 2
          end
          curblock.type = :single
          curblock.tag = :header
          blocks << curblock
          curblock = Block.new

        # horizontal line
        elsif line.start_with?('--') && line.gsub(/-+/, '').length == 0
          a = Block.new
          a.type = :single
          a.tag = :hr
          blocks << a

        else
          # empty line
          if line.gsub(/\s+/, '').length == 0
            blocks << curblock
            curblock = Block.new
            next
          end

          if lindent != curblock.level
            if curblock.lines.length != 0
              blocks << curblock
              curblock = Block.new
            end
            curblock.level = lindent
          end

          curblock.lines << line[lindent * 4..-1]
        end
      end

      lastline = line
    end

    if curblock.lines.length != 0
      blocks << curblock
    end

    blocks
  end
end


class BlogPageGenerator < ContentGenerator

  def generate!
    sections.each do |s|
      @context.row do
        s.display(self)
      end
      
    end

  end
end
