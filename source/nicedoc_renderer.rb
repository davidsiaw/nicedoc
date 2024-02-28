require 'active_support/inflector'

class NicedocRenderer
  def initialize(contents, filename, yaml, debug: false)
    @contents = contents
    @yaml = yaml
    @filename = filename
    @debug = debug
  end

  def dirname
    @filename.split('/')[0..-2].join('/')
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
    filename = @filename

    context.empty_page path, "#{yaml['title'] || "_"}" do
      request_css "css/#{theme}.css"
      rcontext.generate_contents(self)
    end
  end

  def generator_class_name
    "#{pagetype.camelize}PageGenerator"
  end

  def generator_class
    Kernel.const_get(generator_class_name)
  end

  def generate_contents(context)
    cg = generator_class.new(context, @contents, @yaml, @filename)
    cg.debug = @debug
    cg.generate!
  end
end
