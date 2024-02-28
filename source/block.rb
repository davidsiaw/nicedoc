
class Block
  attr_accessor :type, :lines, :tag, :level, :info
  
  def initialize
    @lines = []
    @type = :implicit
    @tag = :div
    @info = {}
    @level = 0
  end
end
