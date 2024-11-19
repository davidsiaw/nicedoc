require 'rouge'
require "csv"


class ExplicitBlockHandler < BlockHandler
  def handle(block, handlerstate, context)
    return false unless block.type == :explicit

    content = block.lines.join("\n")

    lang = block.info[:spec]

    override = false

    if lang&.start_with? "graphviz:"
      File.write(".graphviz.graph.z", content)

      cmd = lang.split(':')[1]

      `#{cmd} .graphviz.graph.z -o .graphviz.graph.svg -Tsvg`

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
          .sub('stroke="white"', 'stroke')
          .sub(/font-family="[^"]+"/, 'font-family fill')
      end

      context.div class:"nicedoc-figureholder" do
        text result.join("")
        # br
        # text "Figure"
      end
      override = true

    elsif lang&.start_with?("plantuml:")

      cmd = lang.split(':')[1]

      File.write(".plantuml.txt", <<~CONTENT)
      @start#{cmd}
      #{content}
      @end#{cmd}
      CONTENT

      `java -jar /plantuml-lgpl-1.2024.8.jar -tsvg .plantuml.txt`

      dotout = File.read(".plantuml.svg")
      content = dotout

      result = []
      content.lines do |line|
        if line.start_with?('<svg')
          #result << line.sub(/width="[0-9]+pt" height="[0-9]+pt"/, '\\1 class: img-responsive')
          line = line.sub('<svg', '<svg class="img-responsive nicedoc-figure"')
          started = true
        end

        # remove all styling shit so we can use css
        result << line
          .gsub('fill="black"', 'fill')
          .gsub('stroke="black"', 'stroke')
          .gsub('fill="white"', 'fill')
          .gsub('stroke="white"', 'stroke')
          .gsub(/style="[^"]+"/, 'style')
          .gsub(/fill="[^"]+"/, 'fill')
          .gsub(/stroke="[^"]+"/, 'stroke')
      end

      context.div class:"nicedoc-figureholder" do
        text result.join("")
        # br
        # text "Figure"
      end
      override = true


    elsif lang == "ditaa"
      File.write(".ditaa.txt", <<~CONTENT)
      #{content}
      CONTENT

      `java -jar /ditaa-0.11.0-standalone.jar --svg .ditaa.txt .ditaa.svg`

      dotout = File.read(".ditaa.svg")
      content = dotout

      result = []
      content.lines do |line|
        if line.start_with?('<svg')
          #result << line.sub(/width="[0-9]+pt" height="[0-9]+pt"/, '\\1 class: img-responsive')
          line = line.sub('<svg', '<svg class="img-responsive nicedoc-figure"')
          started = true
        end
        # remove all styling shit so we can use css
        result << line
          .gsub(/style='[^']+'/, 'style')
          .gsub(/fill='[^']+'/, 'fill')
          .gsub(/stroke='[^']+'/, 'stroke')
          .gsub(/filter='[^']+'/, 'filter')
      end

      context.div class:"nicedoc-figureholder" do
        text result.join("")
        # br
        # text "Figure"
      end
      override = true

    elsif lang == "wireviz"
      File.write(".wireviz.txt", <<~CONTENT)
      #{content}
      CONTENT

      `wireviz -o wireviz.svg -fs .wireviz.txt`

      dotout = File.read("wireviz.svg/.wireviz.svg")
      content = dotout

      result = []
      content.lines do |line|
        if line.start_with?('<svg')
          #result << line.sub(/width="[0-9]+pt" height="[0-9]+pt"/, '\\1 class: img-responsive')
          line = line.sub('<svg', '<svg class="img-responsive nicedoc-figure"')
          started = true
        end
        # remove all styling shit so we can use css
        result << line
          .gsub(/style='[^']+'/, 'style')
          .gsub(/fill='[^']+'/, 'fill')
          .gsub(/stroke='[^']+'/, 'stroke')
          .gsub(/filter='[^']+'/, 'filter')
          .gsub(/style="[^"]+"/, 'style')
          .gsub(/fill="[^"]+"/, 'fill')
          .gsub(/stroke="[^"]+"/, 'stroke')
      end

      context.div class:"nicedoc-figureholder" do
        text result.join("")
        # br
        # text "Figure"
      end
      override = true

    elsif lang == "nwdiag"
      File.write(".nwdiag.txt", <<~CONTENT)
      #{content}
      CONTENT

      `wireviz -o wireviz.svg -fs .wireviz.txt`

      dotout = File.read("wireviz.svg/.wireviz.svg")
      content = dotout

      result = []
      content.lines do |line|
        if line.start_with?('<svg')
          #result << line.sub(/width="[0-9]+pt" height="[0-9]+pt"/, '\\1 class: img-responsive')
          line = line.sub('<svg', '<svg class="img-responsive nicedoc-figure"')
          started = true
        end
        # remove all styling shit so we can use css
        result << line
          .gsub(/style='[^']+'/, 'style')
          .gsub(/fill='[^']+'/, 'fill')
          .gsub(/stroke='[^']+'/, 'stroke')
          .gsub(/filter='[^']+'/, 'filter')
          .gsub(/style="[^"]+"/, 'style')
          .gsub(/fill="[^"]+"/, 'fill')
          .gsub(/stroke="[^"]+"/, 'stroke')
      end

      context.div class:"nicedoc-figureholder" do
        text result.join("")
        # br
        # text "Figure"
      end
      override = true

    elsif lang == "image"
      info = YAML.load(content)
      context.div class:"nicedoc-figureholder" do
        img src: "/images/#{info['src']}", class: "img-responsive nicedoc-figure", alt: "#{info['alt']}"
        # br
        # text "Figure #{info['alt']}"
      end
      override = true

    elsif lang == "csv" || lang == "csvwithheader"
      rows = CSV.parse(content)

      context.row do

        col 1 do
        end
        col 10 do
          table striped: true do
            if lang == "csvwithheader"
              row = rows.shift

              thead do
                row.each do |cell|
                  th do
                    text cell
                  end
                end
              end
            end

            rows.each do |row|
              tr do
                row.each do |cell|
                  td do
                    text cell
                  end
                end
              end
            end
          end
        end
      end
      override = true


    elsif rouge_defined?(lang)
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

  def rouge_defined?(lang)
    formatter = Rouge::Formatters::HTML.new
    lexer_class_name = "Rouge::Lexers::#{lang.camelize}"
    Object.const_defined?(lexer_class_name)
  rescue
    false
  end
end
