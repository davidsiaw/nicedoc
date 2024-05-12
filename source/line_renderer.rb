
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
    cur_dir.sub(/^#{root_dir}/, '')
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

    "#{pi.root_page}#{abs_url_path[0..-2]}.nd"
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

            renderer = renderclass.new(self, arspan, pi)
            renderer.render
          end

        end # arr[:array].each do |arspan|

      end # context.send(@override) do

    end
  end
end
