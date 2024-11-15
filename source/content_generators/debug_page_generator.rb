require_relative 'base_page_generator'

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
                  text "parse: #{block.parse.to_yaml}\n"
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
