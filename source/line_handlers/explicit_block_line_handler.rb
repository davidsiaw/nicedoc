# - explicit block "```"
class ExplicitBlockLineHandler
  REGEX = /```(?<stuff>.+)/

  def handle(line, blocks, curblock)
    if line.start_with?('```')
      if curblock.type == :explicit
        #end
        blocks << curblock
        curblock = Block.new

      else
        #start
        if curblock.lines.length != 0
          blocks << curblock
          curblock = Block.new
        end
        
        curblock.type = :explicit
      end

      m = line.match(REGEX)

      if m != nil && m[:stuff].length != 0
        curblock.info[:spec] = m[:stuff]
      end

      return curblock, :consumed

    elsif curblock.type == :explicit
      curblock.lines << line
      return curblock, :consumed
    end

    return curblock, :notconsumed
  end
end
