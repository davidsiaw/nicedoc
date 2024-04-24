class ExplicitBlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :explicit

    context.pre do
      text block.lines.length.to_s
      block.lines.each do |line|
        text "#{line}\n"
      end
    end

    true
  end
end
