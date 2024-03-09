class EmptyLineHandler
  def handle(line, blocks, curblock)
    return curblock, :notconsumed unless line.gsub(/\s+/, '').length == 0

    if curblock.type != :empty
      if curblock.lines.length != 0
        blocks << curblock
        curblock = Block.new
      end

      curblock.type = :empty
    else
      curblock.type = :break
      blocks << curblock
      curblock = Block.new
    end
  
    return curblock, :consumed
  end
end
