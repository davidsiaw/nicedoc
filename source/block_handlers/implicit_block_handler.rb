class ImplicitBlockHandler < BlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :implicit

    lr = LineRenderer.new(block.parse)
    lr.render(context)

    true
  end
end
