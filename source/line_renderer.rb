
class DefaultSpanRenderer
  def initialize(context, arspan)
    @context = context
    @arspan = arspan
  end

  def render
    @context.span @arspan[:text], class: @arspan[:styles].map{|x| "span-#{x}"}.join(' ')
  end
end

require "erb"
class DblsquareOverrideRenderer < DefaultSpanRenderer
  def url
    front = ""
    back = ""
    res = @arspan[:text]

    if res.start_with?('#')
      front += '#'
      res = res[1..-1]
    else
      back = "/"
    end

    if res.end_with?('/')
      res = res[0..-2]
    end

    front + ERB::Util.url_encode(res) + back
  end

  def text
    res = @arspan[:text]

    if res.end_with?('/')
      res = res[0..-2]
    end

    if res.start_with?('#')
      res = res[1..-1]
    end

    res
  end

  def render
    @context.a text, href: url
  end
end

class LineRenderer
  def initialize(parse, override: :span)
    @parse = parse
    @override = override
  end

  def render(context)
    @parse.each do |arr|

      context.send(@override) do

        arr[:array].each do |arspan|

          if arspan[:styles].length == 0
            text arspan[:text]
          else
            renderclass = DefaultSpanRenderer

            # if the innermost span is something special we render it differently
            override_renderer_name = "#{arspan[:styles].last.to_s.camelize}OverrideRenderer"
            if Object.const_defined?(override_renderer_name)
              renderclass = Object.const_get(override_renderer_name)
            end

            renderer = renderclass.new(self, arspan)
            renderer.render
          end

        end # arr[:array].each do |arspan|

      end # context.send(@override) do

    end
  end
end
