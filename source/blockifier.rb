# Blockifier
# turns lines to blocks
# block types
# - single line "# " "- " "  - " "> " "> > "
# - header block "----", "===="
# - explicit block "```"
# - implicit block
class Blockifier
  attr_reader :lines
  def initialize(lines)
    @lines = lines
  end

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

  def blocks
    blocks = []

    curblock = Block.new
    lastline = nil

    lines.each do |line|
      sbt = single_block_type(line)

      if curblock.type == :explicit
        if line.start_with?('```')
          blocks << curblock

          curblock = Block.new

        else
          curblock.lines << line
        end
        next
      end

      if curblock.lines.length == 0 && !sbt.nil?
        a = Block.new
        a.lines << sbt[:text]
        a.type = :single
        a.tag = sbt[:tag].to_sym
        a.level = sbt[:level]

        blocks << a
        next
      end

      if curblock.type == :implicit

        lindent = 0
        if line.start_with?(' ' * 4)
          lindent = 1
        end
          
        if line.start_with?('```')
          if curblock.lines.length != 0
            blocks << curblock
          end
          curblock = Block.new
          curblock.type = :explicit
          curblock.tag = :pre
          next

        # underline for header
        elsif curblock.lines.length == 1 &&
              (line.start_with?('--') || line.start_with?('==')) &&
              line.length >= curblock.lines[0].length

          if line.start_with?('==')
            curblock.level = 1
          else
            curblock.level = 2
          end
          curblock.type = :single
          curblock.tag = :header
          blocks << curblock
          curblock = Block.new

        # horizontal line
        elsif line.start_with?('--') && line.gsub(/-+/, '').length == 0
          a = Block.new
          a.type = :single
          a.tag = :hr
          blocks << a

        else
          # empty line
          if line.gsub(/\s+/, '').length == 0
            blocks << curblock
            curblock = Block.new
            next
          end

          if lindent != curblock.level
            if curblock.lines.length != 0
              blocks << curblock
              curblock = Block.new
            end
            curblock.level = lindent
          end

          curblock.lines << line[lindent * 4..-1]
        end
      end

      lastline = line
    end

    if curblock.lines.length != 0
      blocks << curblock
    end

    blocks
  end
end
