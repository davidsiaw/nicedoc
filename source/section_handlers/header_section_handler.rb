class HeaderSectionHandler < SectionHandler
  def handle(section, context)
    return false unless section.type == :header

    context.send(:"h#{section.headerlevel}", section.blocks.first.lines.first)
    true
  end
end
