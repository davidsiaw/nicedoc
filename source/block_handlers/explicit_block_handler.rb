require 'rouge'

class ExplicitBlockHandler < BlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :explicit

    content = block.lines.join("\n")

    lang = block.info[:spec]

    override = false

    if lang == "graphviz:dot"
      File.write(".graphviz.graph.dot", content)

      `dot .graphviz.graph.dot -o .graphviz.graph.svg -Tsvg`

      dotout = File.read(".graphviz.graph.svg")
      content = dotout

      result = []
      started = false
      content.lines do |line|

        if line.start_with?('<svg')
          #result << line.sub(/width="[0-9]+pt" height="[0-9]+pt"/, '\\1 class: img-responsive')
          result << line.sub('<svg', '<svg class="img-responsive nicedoc-figure"')
          started = true
          next
        end

        next unless started

        # remove all styling shit so we can use css
        result << line
          .sub('fill="black"', 'fill')
          .sub('stroke="black"', 'stroke')
          .sub('fill="white"', 'fill')
          .sub('stroke="blawhiteck"', 'stroke')
          .sub(/font-family="[^"]+"/, 'font-family fill')
      end

      context.div class:"nicedoc-figureholder" do
        text result.join("")
        br
        text "Figure"
      end
      override = true

    elsif lang == "image"
      info = YAML.load(content)
      context.div class:"nicedoc-figureholder" do
        image "#{info['src']}", class: "nicedoc-figure"
        br
        text "Figure"
      end
      override = true


    elsif !lang.nil?
      formatter = Rouge::Formatters::HTML.new
      lexer_class_name = "Rouge::Lexers::#{lang.camelize}"
      if Object.const_defined?(lexer_class_name)
        lexer = Object.const_get(lexer_class_name).new
        content =  formatter.format(lexer.lex(content))
      end
    end

    context.pre class: "highlight" do
      #text block.lines.length.to_s

      text content
    end unless override

    true
  end
end
