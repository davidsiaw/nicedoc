require_relative 'nicedoc_renderer'
require_relative "span"
require_relative "block"
require_relative "blockifier"
require_relative "section"
require_relative "sectionifier"
require_relative "content_generator"
require_relative "content_generators/blog_page_generator"
require_relative "util"

class Nicedoc
  def initialize(filename, debug: false)
    @filename = filename
    @debug = debug
  end

  def contents
    @contents ||= File.read(@filename)
  end

  def yaml
    @yaml ||= YAML.load(contents.split("---").first)
  end

  def renderer
    NicedocRenderer.new(contents.split("---", 2).last, @filename, yaml, debug: @debug)
  end
end
