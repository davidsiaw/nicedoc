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
    NicedocRenderer.new(contents.split("\n---\n", 2).last, @filename, yaml, debug: @debug)
  end
end
