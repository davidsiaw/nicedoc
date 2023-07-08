class Block
    attr_reader :type, :lines
  
    def initialize(type:, lines:)
      @type = type
      @lines = lines
    end
  
    def spans
      lines.map {|x| Span.new(x)}
    end
  
    def generate(context)
      spanlist = spans
      spanlist.each do |span|
        span.generate(context)
      end
    end
  
    def to_s
      @lines.join(' ')
    end
  end
  