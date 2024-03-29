class ImplicitBlockHandler < BlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :implicit

    lr = LineRenderer.new(block.parse)

    context.send(block.tag) do
      lr.render(self)
    end

    true
  end
end
