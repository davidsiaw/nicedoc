class ListBlockHandler < BlockHandler
  def counter
    @counter ||= 0

    @counter += 1
  end

  def handle(block, handlerstate, context)
    return false unless block.type == :list

    block.info[:tags].each do |tag|
      next unless tag[:parent].nil?

      write_list(block.info, tag, context)
    end

    true
  end

  def write_list(info, tag, context)
    this = self
    context.send(tag[:tag]) do

      tag[:children].each do |child_idx|
        child = info[:tags][child_idx]

        if child[:type] == :branch
          this.write_list(info, child, self)
        else
          li do
            child[:text].each do |textline|
              div textline
            end
          end
        end

      end

    end
  end

end
