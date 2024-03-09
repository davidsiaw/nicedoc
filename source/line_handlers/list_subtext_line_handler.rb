class ListSubtextLineHandler
  def handle(line, blocks, curblock)

    lst = blocks.last
    if lst&.type == :list
      z = lst.info[:tags].last
      level = z[:parent][:level]

      startlevel = level + 2
      if line.start_with?(" " * startlevel) && line[startlevel] != " "
        z[:text] << line[startlevel..-1]
        return curblock, :consumed
      end
    end

    return curblock, :notconsumed
  end
end
