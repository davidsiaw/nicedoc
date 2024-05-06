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
    if type == :list
      info[:tags].map do |tag|
        thing = { **tag }
        if tag[:text]
          thing[:parse] = tag[:text].map{ |line| LineParser.new(line).tree }
        end
        thing

      end
    else
      lineparse
    end
  end

  def lineparse
    @lines.map { |line| LineParser.new(line).tree }
  end
end
