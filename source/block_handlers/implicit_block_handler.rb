class ImplicitBlockHandler < BlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :implicit

    override = :span
    override = :div if block.tag == :div

    pi = @pi

    firstchar = nil
    drop = false
    if pi.yaml["type"] == "opinion" || pi.yaml["type"] == "article" && block.tag == :p
      firstline = block.parse[0]
      text = nil

      if !firstline.nil? 
        firstchar = firstline[:array][0][:text][0]
        block.lines[0] = block.lines[0][1..-1]
      end

      drop = true
    end

    lr = LineRenderer.new(block.parse, @pi, override: override)

    context.send(block.tag) do
      span class: :dropcap do
        text "#{firstchar}"
      end if drop

      lr.render(self)
    end

    true
  end
end
