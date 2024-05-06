class Nicedoc
  def initialize(pi, debug: false)
    @pi = pi
    @debug = debug
  end

  def filename
    @pi.cur_page
  end

  def contents
    @contents ||= File.read(filename)
  end

  def yaml
    @yaml ||= YAML.load(contents.split("---").first)
  end

  def renderer
    NicedocRenderer.new(contents.split("\n---\n", 2).last, @pi, yaml, debug: @debug)
  end
end
