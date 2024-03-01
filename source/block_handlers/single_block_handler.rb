class SingleBlockHandler < BlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :single

    true
  end
end
