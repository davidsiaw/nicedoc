
class DefaultSpanRenderer
  attr_reader :pi

  def initialize(context, arspan, pi)
    @context = context
    @arspan = arspan
    @pi = pi
  end

  def render
    @context.span @arspan[:text], class: @arspan[:styles].map{|x| "span-#{x}"}.join(' ')
  end
end

require "erb"

class LocalLinkHelper
  def initialize(top_file:, current_file:)
    @top_file = top_file
    @current_file = current_file
  end

  def root_dir
    @top_file.sub(%r{/top.nd$}, '')
  end

  def cur_dir
    @current_file.sub(%r{top.nd$}, '')
  end

  def rel_path
    raw_rel_path = cur_dir.sub(/^#{root_dir}/, '')
    toks = raw_rel_path.split('/')

    p toks

    proctocs = []
    toks.each do |x|
      if x == '..'
        proctocs.push (x)
      elsif proctocs.length > 0
        proctocs.pop
      end
    end

    proctocs.join('/')


  end

  def equiv_file(val)
    if val == '/'
      return @top_file
    end

    rel_path
  end

  def equiv_url(val)
  end

  def error?(val)
  end

end

class LinkHelper
  def initialize(root: '/')
    @root = root
  end

  def anchor?(val)
    val.start_with?('#')
  end

  def external?(val)
    val.start_with?(%r{https?://})
  end

  def local?(val)
    !anchor?(val) && !external?(val)
  end

  def url_for_local(val)
    toks = val.split('/')

    if toks.length == 0
      return @root
    end
    @root + toks.join('/') + '/'
  end

end

class DblsquareOverrideRenderer < DefaultSpanRenderer

  def ref_filename
    return "ERR_LONGFORM" if longform?

    if this_is_top?
      return "#{pi.root_page}#{abs_url_path}.nd"
    end

    "#{pi.root_page}#{processed_url_path}.nd"
  end

  def processed_url_path
    toks = abs_url_path.split('/')

    proctocs = []
    toks.each do |x|
      if x != '..'
        proctocs.push (x)
      elsif proctocs.length > 0
        proctocs.pop
      end
    end

    proctocs.join('/')
  end

  def page_title
    return "ERR_UNKNOWN(#{ref_filename})" unless exists?

    YAML.load(File.read(ref_filename))['title']
  end

  def this_is_top?
    pi.cur_page == "#{pi.root_page}/top.nd"
  end

  def dir
    if this_is_top?
      return pi.cur_page.split('/')[0..-2].join('/')
    end

    pi.cur_page.sub(/\.nd$/, '')
  end

  def abs_url_path
    if this_is_top?
      return "/#{@arspan[:text]}"
    end

    "#{pi.rel_filepath.sub(/\.nd$/, '')}/#{@arspan[:text]}/"
  end

  def exists?
    return true if longform?

    File.exist?(ref_filename)
  end

  def longform?
    return true if @arspan[:text].start_with?(%r{https?://})

    false
  end

  def anchor?
    @arspan[:text].start_with?('#')
  end

  def url
    return @arspan[:text] if longform?
    return @arspan[:text] if anchor?
    return '#' if !exists?

    abs_url_path
  end

  def text
    return @arspan[:text] if longform?
    return @arspan[:text][1..-1] if anchor?

    page_title
  end

  def render
    @context.a text, href: url
  end
end


class SqparensOverrideRenderer < DefaultSpanRenderer

  def latek
    @arspan[:text]
  end

  def safestring
    str = latek.
      sub('"', '\\"').
      sub("'", "\\'").
      sub("!", "\\!").
      sub("$", "\\$").
      sub("`", "\\`").
      sub("~", "\\~").
      sub("\n", "").
      sub("\r", "").
      sub("\\", "\\\\")

    %{"#{str}"}
  end

  def mjoutput
    @mjoutput ||= `node_modules/.bin/am2htmlcss #{safestring}`
  end

  def mjlines
    @mjlines ||= mjoutput.split("\n")
  end

  def css
    mjlines[ mjlines.index('<style>')..mjlines.index('</style>') ]
  end

  def body
    mjlines[ mjlines.index('<body>')+1..mjlines.index('</body>')-1 ]
  end

  def render

    @context.text css
    @context.text body

    #@context.span @arspan[:text], class: @arspan[:styles].map{|x| "span-bold"}.join(' ')

  end
end

class LineRenderer
  def initialize(parse, pi, override: )
    @pi = pi
    @parse = parse
    @override = override
  end

  def render(context)
    pi = @pi
    @parse.each do |arr|

      # binding.pry

      context.send(@override) do

        arr[:array].each_with_index do |arspan, idx|

          prev_arspan = arr[:array][idx-1]
          next_arspan = arr[:array][idx+1]

          prev_style = prev_arspan.nil? || prev_arspan[:styles].nil?  ? nil : prev_arspan[:styles][0]
          next_style = next_arspan.nil? || next_arspan[:styles].nil?  ? nil : next_arspan[:styles][0]
          curr_style = arspan.nil? || arspan[:styles].nil?  ? nil : arspan[:styles][0]

          # support for markdown style links
          front_mdlink = curr_style == :square && next_style == :parens
          commit_mdlink = prev_style == :square && curr_style == :parens

          if front_mdlink
            # if we see the pattern, don't render this and move next
            next

          elsif commit_mdlink
            # if we see the pattern behind us, render all the info
            a prev_arspan[:text], href: arspan[:text]

          elsif arspan[:styles].length == 0
            text arspan[:text]

          else
            renderclass = DefaultSpanRenderer

            # if the innermost span is something special we render it differently
            override_renderer_name = "#{arspan[:styles].last.to_s.camelize}OverrideRenderer"

            if Object.const_defined?(override_renderer_name)
              renderclass = Object.const_get(override_renderer_name)
            end

            renderer = renderclass.new(self, arspan, pi)
            renderer.render
          end

        end # arr[:array].each do |arspan|

      end # context.send(@override) do

    end
  end
end
