class LineRenderer
  def initialize(parse)
    @parse = parse
  end

  def render(context)
    @parse.each do |arr|
      typ = :div

      if ((arr || {})[:array]&.first || {})[:text]&.start_with?('  ')
        typ = :p
      end

      context.send(typ) do
        arr[:array].each do |arspan|
          span arspan[:text], class: arspan[:styles].map{|x| "span-#{x}"}.join(' ')
        end
      end
    end
  end
end
