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

    return curblock, :notconsumed unless curblock.lines.length == 0 && !sbt.nil?

    a = Block.new
    a.lines << sbt[:text]
    a.type = :single
    a.tag = sbt[:tag].to_sym
    a.level = sbt[:level]

    blocks << a

    return curblock, :consumed
  end
end
