class Span
  attr_reader :type, :line
  def initialize(line, type=:normal)
    @type = type
    @line = line
  end

  TYPES = [
    ['**', :bold],
    ['*', :italic],
    ['__', :underline],
    ['^^', :overline],
    ['--', :strikeout]
  ]

  def innerspans
    TYPES.each do |delim, curtype|
      toks = @line.split(delim)
  
      if toks.length > 2 && (toks.length & 1) == 1
        return toks.each_with_index.map do |x, i|
          odd = i & 1 == 1
          s = Span.new(x, odd ? curtype : @type)
          s = s.innerspans || s
        end
      end
    end
    nil
  end

  def generate(context)
    spanlist = innerspans&.flatten
    line = @line
    context.instance_exec do
      if spanlist.nil?
        span line
      else
        spanlist.each do |x|
          span x.line, class: "n_#{x.type}"
        end
      end
      span ' '
    end
  end
end
