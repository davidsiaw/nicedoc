class ImplicitBlockHandler < BlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :implicit

    block.lines.each do |line|
      context.div "#{line}\n"
    end

    true
  end
end
