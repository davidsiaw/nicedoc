
class Nicedoc
  def initialize(contents)
    @contents = contents
  end

  def yaml
    @yaml ||= YAML.load(@contents.split("---").first)
  end

  def renderer
    NicedocRenderer.new(@contents.split("---", 2).last, yaml)
  end
end
