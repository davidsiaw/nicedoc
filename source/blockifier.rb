# Blockifier
# turns lines to blocks
class Blockifier
  attr_reader :lines
  def initialize(lines)
    @lines = lines
  end

  def handler_list
    @handler_list ||= [
      HeaderUnderlineLineHandler.new,
      HorizontalLineHandler.new,
      ExplicitBlockLineHandler.new,
      ListLineHandler.new,
      ListSubtextLineHandler.new,
      SingleLineHandler.new,
      CodeBlockLineHandler.new,
      EmptyLineHandler.new,
      IndentedLineHandler.new,
      ImplicitLineHandler.new
    ]
  end

  def blocks
    blocks = []

    curblock = Block.new
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
    end

    if curblock.lines.length != 0
      blocks << curblock
    end

    blocks
  end
end
