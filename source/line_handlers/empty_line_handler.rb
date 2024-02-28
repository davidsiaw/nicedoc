class EmptyLineHandler
  def handle(line, blocks, curblock)
    return curblock, :notconsumed unless line.gsub(/\s+/, '').length == 0

    # empty line
    if curblock.lines.length != 0
      blocks << curblock
    end
    curblock = Block.new
  
    return curblock, :consumed
  end
end
