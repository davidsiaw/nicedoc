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
                  text "type: #{block.type}\n"
                  text "level: #{block.level}\n"
                  text "lines: #{block.lines.count}\n"
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

class BlogPageGenerator < ContentGenerator
  def generate!
    sections.each do |s|
      s.display(@context, debug: debug)
    end
  end
end
