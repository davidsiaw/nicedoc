
class Nicedoc
  def initialize(filename)
    @filename = filename
  end

  def contents
    @contents ||= File.read(@filename)
  end

  def yaml
    @yaml ||= YAML.load(contents.split("---").first)
  end

  def renderer
    NicedocRenderer.new(contents.split("---", 2).last, @filename, yaml)
  end
end
