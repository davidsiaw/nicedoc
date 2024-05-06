class IndentedBlockHandler < BlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :indented

    context.pre do
      #text block.lines.length.to_s
      block.lines.each do |line|
        text "#{line}"
      end
    end

    true
  end
  # def handle(block, handlerstate, context)
  #   return false unless block.type == :indented

  #   lr = LineRenderer.new(block.parse)

  #   context.send(:pre) do
  #     lr.render(self)
  #   end

  #   true
  # end
end
