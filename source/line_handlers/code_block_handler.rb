class CodeBlockHandler
  REGEX = /```(?<stuff>.+)/

  def handle(line, blocks, curblock)
    return curblock, :notconsumed unless curblock.type == :implicit
    return curblock, :notconsumed unless line.start_with?('```')

    if curblock.lines.length != 0
      blocks << curblock
    end

    curblock = Block.new
    curblock.info[:spec] = ''

    m = line.match(REGEX)
    if m != nil && m[:stuff].length != 0
      curblock.info[:spec] = m[:stuff]
    end

    curblock.type = :explicit
    curblock.tag = :pre

    return curblock, :consumed
  end
end
