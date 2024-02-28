class HorizontalLineHandler
  def handle(line, blocks, curblock)
    return curblock, :notconsumed unless line.start_with?('--') 
    return curblock, :notconsumed unless line.gsub(/-+/, '').length == 0

    a = Block.new
    a.type = :single
    a.tag = :hr
    blocks << a
  
    return curblock, :consumed
  end
end
