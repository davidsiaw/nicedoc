class FlatSectionList
  attr_reader :sections

  def initialize(sections)
    @sections = sections
  end

  def flatlist
    @flatlist ||= begin
      list = []
      sections.each do |s|
        insert_into_flatlist(list, s)
      end
      list
    end
  end

  def insert_into_flatlist(list, s)
    list << s

    s.children.each do |child|
      insert_into_flatlist(list, child)
    end
  end
end
