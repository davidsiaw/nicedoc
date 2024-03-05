class HeaderSectionHandler < SectionHandler
  def handle(section, context)
    return false unless section.type == :header

    context.send(:"h#{section.headerlevel}") do

      lr = LineRenderer.new(section.blocks.first.parse)
      lr.render(self)

      #text section.blocks.first.lines.first
      
    end
    true
  end
end
