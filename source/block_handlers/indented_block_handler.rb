class IndentedBlockHandler < BlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :indented

    lr = LineRenderer.new(block.parse)

    context.send(:pre) do
      lr.render(self)
    end

    true
  end
end
