class ImplicitBlockHandler < BlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :implicit

    override = :span
    override = :div if block.tag == :div
    lr = LineRenderer.new(block.parse, @pi, override: override)

    context.send(block.tag) do
      lr.render(self)
    end

    true
  end
end
