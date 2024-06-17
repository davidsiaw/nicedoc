require 'active_support/inflector'

class NicedocRenderer
  def initialize(contents, pi, yaml, debug: false)
    @contents = contents
    @yaml = yaml
    @debug = debug
    @pi = pi
    pi.yaml = yaml
  end

  def filename
    @pi.cur_page
  end

  def dirname
    filename.split('/')[0..-2].join('/')
  end

  def theme
    @yaml['theme'] || "indigo"
  end

  def pagetype
    @yaml['type'] || 'manual'
  end

  def generate(path, context)
    rcontext = self
    yaml = @yaml
    theme = self.theme
    pi = @pi

    context.empty_page path, "#{yaml['title'] || "_"}" do
      self.define_singleton_method(:page_info) do
        return pi
      end

      request_css "css/#{theme}-#{yaml['type']}.css"
      rcontext.generate_contents(self)
    end
  end

  def generator_class_name
    "#{pagetype.camelize}PageGenerator"
  end

  def generator_class
    return DebugPageGenerator if @debug

    Kernel.const_get(generator_class_name)
  end

  def generate_contents(context)
    pi = @pi
    cg = generator_class.new(context, @pi, @contents, @yaml, filename)
    cg.generate!
  end
end





























