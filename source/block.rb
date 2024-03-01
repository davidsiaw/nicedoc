
class Block
  attr_accessor :type, :lines, :tag, :level, :info
  
  def initialize
    @lines = []
    @type = :implicit
    @tag = :div
    @info = {}
    @level = 0
  end

  def parse
    @lines.map { |line| LineParser.new(line).tree }
    
  end
end

WATCHCHARS = Set.new([
  '*',
  '/',
  '_',
  '^',
  '-',
  '~',
  '[',
  ']',
  '(',
  ')',
  '{',
  '}',
  '<',
  '>'
])

class LineParser
  def initialize(text)
    @text = text
  end

  def tree
    return {} if @text.nil?

    charposes = {}

    @text.split('').each_with_index do |chr, index|
      if WATCHCHARS.include?(chr)
        charposes[chr] ||= []
        charposes[chr] << index
      end
    end

    

    {
      charposes: charposes,
    }
  end
end
