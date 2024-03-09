class IndentedLineHandler
  def handle(line, blocks, curblock)

    lindent = 0
    if line.start_with?('    ')
      lindent = 1
    end

    return curblock, :notconsumed if lindent != 1

    prefix = "\n"
    if curblock.type != :indented
      if curblock.lines.length != 0
        blocks << curblock
        curblock = Block.new
      end
      curblock.type = :indented
      curblock.level = lindent
      prefix = ""
    end

    curblock.lines << prefix + line[lindent * 4..-1]

    return curblock, :consumed
  end
end
