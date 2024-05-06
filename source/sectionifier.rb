# Sectionifier
# turns blocks into semantic sections
class Sectionifier
  def initialize(blocks, pi)
    @blocks = blocks
    @pi = pi
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

        # elsif curblock.tag == :ol || curblock.tag == :ul
        #   cursection.type = curblock.tag
        #   cursection.listlevel = curblock.level
        #   next

        else
          cursection.type = :para
        end

      elsif cursection.type == :ol || cursection.type == :ul
        # handling for lists
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

      elsif cursection.type == :header
        # handling for header

        if curblock.tag == :header
          if cursection.type == :header && curblock.level > cursection.headerlevel
            inner = Section.new
            blocks = consume_block(blocks, inner)
            cursection.children << inner
            next
          end
          break
        end

      elsif cursection.type == :para

        if curblock.tag == :header
          break
        # elsif curblock.tag == :ol || curblock.tag == :ul
        #   inner = Section.new
        #   blocks = consume_block(blocks, inner)
        #   cursection.children << inner
        #   next
          
        end

      else
        raise "unhandled section type: #{cursection.type}"

      end

      cursection.blocks << curblock

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
        cursection.pi = @pi
        result << cursection
        break if remaining.length.zero?
      end
      
      result
    end
  end
end
