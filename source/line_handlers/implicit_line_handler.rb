class ImplicitLineHandler
  def handle(line, blocks, curblock)
    if curblock.type != :implicit
      blocks << curblock
      curblock = Block.new
    end

    # lindent = line.split('    ', -1).length - 1

    if curblock.tag == :div && curblock.lines.length == 0 && line.start_with?('  ')
      curblock.tag = :p
      # first line determines type of block
      curblock.lines << line

    elsif curblock.tag == :p
      # paragraphs are collapsed to one line
      curblock.lines[0] += " #{line}"

    elsif curblock.tag == :div
      curblock.lines << line
    end




    return curblock, :consumed
  end
end
