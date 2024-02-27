
class Block
  attr_accessor :type, :lines, :tag, :level
  
  def initialize
    @lines = []
    @type = :implicit
    @tag = :div
    @level = 0
  end
end
