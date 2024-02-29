# - explicit block "```"
class ExplicitBlockLineHandler
  def handle(line, blocks, curblock)
    return curblock, :notconsumed unless curblock.type == :explicit

    if line.start_with?('```')
      if curblock.lines.length != 0
        blocks << curblock
      end

      curblock = Block.new

    else
      curblock.lines << line
    end
    
    return curblock, :consumed
  end
end
