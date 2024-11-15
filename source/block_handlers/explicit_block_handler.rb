require 'rouge'

class ExplicitBlockHandler < BlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :explicit

    content = block.lines.join("\n")

    lang = block.info[:spec]

    if !lang.nil?
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
    end

    true
  end
end
