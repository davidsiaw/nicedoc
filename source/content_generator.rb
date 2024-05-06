class ContentGenerator
  attr_accessor :contents, :yaml, :filename, :pi

  def initialize(context, pi, contents, yaml, filename)
    @context = context
    @contents = contents
    @yaml = yaml
    @filename = filename
    @pi = pi
  end

  def lines
    @lines ||= @contents.split("\n")
  end

  def blocks
    Blockifier.new(lines).blocks
  end

  def sections
    Sectionifier.new(blocks, @pi).sections
  end

  def generate!
    @context.text "empty content generator"
  end
  
  def flatlist
    @flatlist ||= FlatSectionList.new(sections).flatlist
  end
end
