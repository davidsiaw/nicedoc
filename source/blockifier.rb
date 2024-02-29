# Blockifier
# turns lines to blocks
class Blockifier
  attr_reader :lines
  def initialize(lines)
    @lines = lines
  end

  def handler_list
    @handler_list ||= [
      ExplicitBlockLineHandler.new,
      ListLineHandler.new,
      SingleLineHandler.new,
      CodeBlockLineHandler.new,
      HeaderUnderlineLineHandler.new,
      HorizontalLineHandler.new,
      EmptyLineHandler.new,
      IndentedLineHandler.new
    ]
  end

  def blocks
    blocks = []

    curblock = Block.new
    lastline = nil

    lines.each do |line|

      consumed = false
      handler_list.each do |handler|
        curblock, status = handler.handle(line, blocks, curblock)
        
        if status == :consumed
          consumed = true
          break
        end
      end

      raise "unconsumed line: #{line}" if consumed == false

      lastline = line
    end

    if curblock.lines.length != 0
      blocks << curblock
    end

    blocks
  end
end
