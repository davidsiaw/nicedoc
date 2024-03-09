class LineRenderer
  def initialize(parse)
    @parse = parse
  end

  def render(context)
    @parse.each do |arr|

      arr[:array].each do |arspan|
        if arspan[:styles].length == 0
          context.text arspan[:text]
        else
          context.span arspan[:text], class: arspan[:styles].map{|x| "span-#{x}"}.join(' ')
        end
      end
    end
  end
end
