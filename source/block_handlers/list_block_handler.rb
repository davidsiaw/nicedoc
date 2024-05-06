class ListBlockHandler < BlockHandler
  def counter
    @counter ||= 0

    @counter += 1
  end

  def handle(block, handlerstate, context)
    return false unless block.type == :list

    block.parse.each do |tag|
      next unless tag[:parent].nil?

      write_list(block, tag, context)
    end

    true
  end

  def write_list(block, tag, context)
    this = self
    context.send(tag[:tag]) do

      tag[:children].each do |child_idx|
        child = block.parse[child_idx]

        if child[:type] == :branch
          this.write_list(block, child, self)
        else
          li do
            lr = LineRenderer.new(child[:parse], override: :div)

            lr.render(self)

            # child[:text].each do |textline|

            #   div textline
            # end
          end
        end

      end

    end
  end

end
