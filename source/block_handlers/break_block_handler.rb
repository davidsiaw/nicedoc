class BreakBlockHandler < BlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :break

    context.br

    true
  end
end
