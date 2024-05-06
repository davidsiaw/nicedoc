class Section
  attr_accessor :blocks, :children, :type, :headerlevel, :listlevel, :pi

  def initialize
    @blocks = []
    @children = []
    @headerlevel = 0
    @listlevel = 0
  end
end
