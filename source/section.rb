class Section
  attr_accessor :blocks, :children, :type, :headerlevel, :listlevel

  def initialize
    @blocks = []
    @children = []
    @headerlevel = 0
    @listlevel = 0
  end

  def display(context, debug:)
    return display_debug(context) if debug

    sect = self
    blocks = @blocks
  end

  def display_debug(context)
    sect = self
    blocks = @blocks
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
          blocks.each do |block|
            pre do
              text "type: #{block.type}\n"
              text "level: #{block.level}\n"
              text "lines: #{block.lines.count}\n"
              block.lines.each do |line|
                text "- #{line}\n"
              end
            end
          end
          
          
          #{blocks.map{|b| b.lines.inspect}.join('|')}"
          sect.children.each do |s|
            s.display(self, debug: true)
          end
        end
      end
    end
    
  end
end
