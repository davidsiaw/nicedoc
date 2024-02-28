class IndentedLineHandler
  def handle(line, blocks, curblock)
    return curblock, :notconsumed unless curblock.type == :implicit

    # lindent = line.split('    ', -1).length - 1

    lindent = 0
    if line.start_with?('    ')
      lindent = 1
    end

    if lindent != curblock.level
      if curblock.lines.length != 0
        blocks << curblock
        curblock = Block.new
      end
      curblock.level = lindent
    end

    curblock.lines << line[lindent * 4..-1]

    return curblock, :consumed
  end
end
