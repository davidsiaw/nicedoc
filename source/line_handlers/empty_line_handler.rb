class EmptyLineHandler
  def handle(line, blocks, curblock)
    return curblock, :notconsumed unless line.gsub(/\s+/, '').length == 0

    # empty line
    if curblock.lines.length == 0
      curblock.type = :empty
      if blocks.last&.type != :empty
        blocks << curblock
      else
        curblock.type = :break
        blocks << curblock
      end
    else
      blocks << curblock
    end
    curblock = Block.new
  
    return curblock, :consumed
  end
end
