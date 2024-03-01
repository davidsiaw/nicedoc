class EmptyBlockHandler < BlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :empty

    true
  end
end
