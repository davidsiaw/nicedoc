# - header block "----", "===="
class HeaderUnderlineHandler
  def handle(line, blocks, curblock)
    return curblock, :notconsumed unless curblock.type == :implicit
    return curblock, :notconsumed unless curblock.lines.length == 1
    return curblock, :notconsumed unless (line.start_with?('--') || line.start_with?('=='))
    return curblock, :notconsumed unless line.length >= curblock.lines[0].length

    if line.start_with?('==')
      curblock.level = 1
    else
      curblock.level = 2
    end
    curblock.type = :single
    curblock.tag = :header
    if curblock.lines.length != 0
      blocks << curblock
    end
    curblock = Block.new

    return curblock, :consumed
  end
end
