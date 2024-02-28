# Sectionifier
# turns blocks into semantic sections
class Sectionifier
  def initialize(blocks)
    @blocks = blocks
  end

  # return remaining blocks
  def consume_block(blocks, cursection)
    loop do
      curblock = blocks.first
      break if curblock.nil?

      # determine the current section type
      if cursection.type.nil?

        if curblock.tag == :header
          cursection.type = :header
          cursection.headerlevel = curblock.level

          # pull in the header
          cursection.blocks << curblock
          blocks.shift

          # continue with the rest
          inner = Section.new
          blocks = consume_block(blocks, inner)
          cursection.children << inner
          next

        elsif curblock.tag == :ol || curblock.tag == :ul
          cursection.type = curblock.tag
          cursection.listlevel = curblock.level
          next

        elsif curblock.type == :implicit
          cursection.type = :para

        else
          cursection.type = curblock.type
        end

      elsif cursection.type == :ol || cursection.type == :ul
        break if curblock.tag != cursection.type
        break if curblock.level < cursection.listlevel
        
        if curblock.level > cursection.listlevel
          inner = Section.new
          blocks = consume_block(blocks, inner)
          cursection.children.last.children << inner
          next

        else
          # equal
          inner = Section.new
          inner.type = :li

          # pull in the header
          inner.blocks << blocks.shift
          cursection.children << inner
          next
        end

      else
        if curblock.tag == :header
          if cursection.type == :header && curblock.level > cursection.headerlevel
            inner = Section.new
            blocks = consume_block(blocks, inner)
            cursection.children << inner
            next
          end
          break
        end

        if curblock.tag == :ol || curblock.tag == :ul
          break
        end

        if curblock.type != :implicit
          break
        end

      end

      if curblock.lines.length != 0
        cursection.blocks << curblock
      end

      blocks.shift
    end

    blocks
  end

  def sections
    @sections ||= begin
      result = []
  
      remaining = @blocks.dup
  
      remaining.length.times do
        cursection = Section.new
        remaining = consume_block(remaining, cursection)
        result << cursection
        break if remaining.length.zero?
      end
      
      result
    end
  end
end
