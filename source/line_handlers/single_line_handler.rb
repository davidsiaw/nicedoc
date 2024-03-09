# - single line "# " "- " "  - " "> " "> > "
class SingleLineHandler
  SINGLE_LINE_BLOCKS = {
    header: {
      regex: %r{^(?<level>\#{1,3}) (?<text>.+)}
    },
    ul: {
      regex: %r{^(?<level> *)- (?<text>.+)}
    },
    ol: {
      regex: %r{^(?<level> *)[0-9]+\. (?<text>.+)}
    },
  }

  def single_block_type(line)
    SINGLE_LINE_BLOCKS.each do |typ, info|
      m = info[:regex].match(line)
      next if m.nil?

      return {
        type: typ,
        tag: typ,
        level: m[:level].length,
        text: m[:text]
      }
    end

    nil
  end

  def handle(line, blocks, curblock)
    sbt = single_block_type(line)

    return curblock, :notconsumed if sbt.nil?

    if curblock.lines.length == 0
      blocks << curblock
      curblock = Block.new
    end

    curblock.lines << sbt[:text]
    curblock.type = :single
    curblock.tag = sbt[:tag].to_sym
    curblock.level = sbt[:level]

    return curblock, :consumed
  end
end
