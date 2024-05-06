class ParaSectionHandler < SectionHandler
  def block_handler_list
    [
      ListBlockHandler.new,
      SingleBlockHandler.new,
      ExplicitBlockHandler.new,
      ImplicitBlockHandler.new,
      IndentedBlockHandler.new,
      BreakBlockHandler.new,
      EmptyBlockHandler.new
    ]
  end

  def handle(section, context)
    return false unless section.type == :para 

    handlerstate = {}
    section.blocks.each do |block|

      consumed_by_handler = false
      block_handler_list.each do |bh|
        bh.pi = @pi
        handled = bh.handle(block, handlerstate, context)

        if handled
          consumed_by_handler = true
          break
        end
      end
      raise "unconsumed block: #{block.type.inspect}" unless consumed_by_handler

      # block.lines.each do |line|
      #   context.div line
      # end
    end
    true
  end
end
