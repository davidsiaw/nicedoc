describe Blockifier do
  it "creates an implicit block" do
    obj = described_class.new(["abc"])

    expect(obj.blocks.length).to eq 1
    expect(obj.blocks[0].type).to eq :implicit
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'abc'
  end

  it "creates h2 header block" do
    obj = described_class.new(["abc", "---"])

    expect(obj.blocks.length).to eq 1
    expect(obj.blocks[0].type).to eq :single
    expect(obj.blocks[0].tag).to eq :header
    expect(obj.blocks[0].level).to eq 2
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'abc'
  end

  it "creates h1 header block" do
    obj = described_class.new(["abc", "==="])

    expect(obj.blocks.length).to eq 1
    expect(obj.blocks[0].type).to eq :single
    expect(obj.blocks[0].tag).to eq :header
    expect(obj.blocks[0].level).to eq 1
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'abc'

  end

  it "does not create a header block if theres an empty line between" do
    obj = described_class.new(["abc", "", "==="])

    expect(obj.blocks.length).to eq 2
    expect(obj.blocks[0].type).to eq :implicit
    expect(obj.blocks[0].tag).to eq :div
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'abc'

    expect(obj.blocks[1].type).to eq :implicit
    expect(obj.blocks[1].tag).to eq :div
    expect(obj.blocks[1].lines.length).to eq 1
    expect(obj.blocks[1].lines[0]).to eq '==='
  end

  it "creates horizontal line single" do
    obj = described_class.new(["---"])

    expect(obj.blocks.length).to eq 1

    expect(obj.blocks[0].type).to eq :single
    expect(obj.blocks[0].tag).to eq :hr
    expect(obj.blocks[0].lines.length).to eq 0
  end

  it "header lines in a row create separate blocks" do
    obj = described_class.new(["# top header", "# another header"])

    expect(obj.blocks.length).to eq 2
    
    expect(obj.blocks[0].type).to eq :single
    expect(obj.blocks[0].tag).to eq :header
    expect(obj.blocks[0].level).to eq 1
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'top header'

    expect(obj.blocks[1].type).to eq :single
    expect(obj.blocks[1].tag).to eq :header
    expect(obj.blocks[1].level).to eq 1
    expect(obj.blocks[1].lines.length).to eq 1
    expect(obj.blocks[1].lines[0]).to eq 'another header'
  end

  it "creates top header line single" do
    obj = described_class.new(["# top header"])

    expect(obj.blocks.length).to eq 1
    
    expect(obj.blocks[0].type).to eq :single
    expect(obj.blocks[0].tag).to eq :header
    expect(obj.blocks[0].level).to eq 1
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'top header'
  end

  it "creates 2nd header line single" do
    obj = described_class.new(["## 2nd header"])

    expect(obj.blocks.length).to eq 1
    
    expect(obj.blocks[0].type).to eq :single
    expect(obj.blocks[0].tag).to eq :header
    expect(obj.blocks[0].level).to eq 2
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq '2nd header'
  end

  it "creates 3rd header line single" do
    obj = described_class.new(["### 3rd header"])

    expect(obj.blocks.length).to eq 1
    
    expect(obj.blocks[0].type).to eq :single
    expect(obj.blocks[0].tag).to eq :header
    expect(obj.blocks[0].level).to eq 3
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq '3rd header'
  end

  it "creates a list block from ordered list" do
    obj = described_class.new(["1. hello"])

    expect(obj.blocks.length).to eq 1
    
    expect(obj.blocks[0].type).to eq :list
    expect(obj.blocks[0].tag).to eq :ol
    expect(obj.blocks[0].level).to eq 0
    expect(obj.blocks[0].lines.length).to eq 0
    expect(obj.blocks[0].info[:tags][0][:type]).to eq :branch
    expect(obj.blocks[0].info[:tags][1][:type]).to eq :leaf
    expect(obj.blocks[0].info[:tags][1][:text]).to eq 'hello'
  end

  it "creates a list block from unordered list" do
    obj = described_class.new(["- world"])

    expect(obj.blocks.length).to eq 1
    
    expect(obj.blocks[0].type).to eq :list
    expect(obj.blocks[0].tag).to eq :ul
    expect(obj.blocks[0].level).to eq 0
    expect(obj.blocks[0].lines.length).to eq 0
    expect(obj.blocks[0].info[:tags][0][:type]).to eq :branch
    expect(obj.blocks[0].info[:tags][1][:type]).to eq :leaf
    expect(obj.blocks[0].info[:tags][1][:text]).to eq 'world'
  end

  it "creates one list block from multiple unordered list lines" do
    obj = described_class.new(["- a", "- b"])

    expect(obj.blocks.length).to eq 1
    
    expect(obj.blocks[0].type).to eq :list
    expect(obj.blocks[0].tag).to eq :ul
    expect(obj.blocks[0].level).to eq 0
    expect(obj.blocks[0].lines.length).to eq 0
    expect(obj.blocks[0].info[:tags][0][:type]).to eq :branch
    expect(obj.blocks[0].info[:tags][1][:type]).to eq :leaf
    expect(obj.blocks[0].info[:tags][1][:text]).to eq 'a'
    expect(obj.blocks[0].info[:tags][2][:type]).to eq :leaf
    expect(obj.blocks[0].info[:tags][2][:text]).to eq 'b'
  end

  it "creates unordered list indented" do
    obj = described_class.new([" - indented"])

    expect(obj.blocks.length).to eq 1
    
    expect(obj.blocks[0].type).to eq :list
    expect(obj.blocks[0].tag).to eq :ul
    expect(obj.blocks[0].level).to eq 0
    expect(obj.blocks[0].lines.length).to eq 0

    expect(obj.blocks[0].info[:tags].length).to eq 2

    expect(obj.blocks[0].info[:tags][0][:type]).to eq :branch
    expect(obj.blocks[0].info[:tags][1][:type]).to eq :leaf
    expect(obj.blocks[0].info[:tags][1][:text]).to eq 'indented'
  end


  it "does not create a header block if theres line after when its a hr" do
    obj = described_class.new(["abc", "", "---"])

    expect(obj.blocks.length).to eq 2

    expect(obj.blocks[0].type).to eq :implicit
    expect(obj.blocks[0].tag).to eq :div
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'abc'

    expect(obj.blocks[1].type).to eq :single
    expect(obj.blocks[1].tag).to eq :hr
    expect(obj.blocks[1].lines.length).to eq 0
  end

  it "creates explicit block" do
    obj = described_class.new(["```", "something", "```"])

    expect(obj.blocks.length).to eq 1
    
    expect(obj.blocks[0].type).to eq :explicit
    expect(obj.blocks[0].tag).to eq :pre
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'something'
  end

  it "creates explicit block even if its not terminated" do
    obj = described_class.new(["```", "something"])

    expect(obj.blocks.length).to eq 1
    
    expect(obj.blocks[0].type).to eq :explicit
    expect(obj.blocks[0].tag).to eq :pre
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'something'
  end

  it "creates explicit block after stuff" do
    obj = described_class.new(["abc", "```", "something", "```"])

    expect(obj.blocks.length).to eq 2
    
    expect(obj.blocks[0].type).to eq :implicit
    expect(obj.blocks[0].tag).to eq :div
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'abc'

    expect(obj.blocks[1].type).to eq :explicit
    expect(obj.blocks[1].tag).to eq :pre
    expect(obj.blocks[1].lines.length).to eq 1
    expect(obj.blocks[1].lines[0]).to eq 'something'
  end

  it "creates explicit block before stuff" do
    obj = described_class.new(["```", "something", "```", "abc"])

    expect(obj.blocks.length).to eq 2
    
    expect(obj.blocks[0].type).to eq :explicit
    expect(obj.blocks[0].tag).to eq :pre
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'something'

    expect(obj.blocks[1].type).to eq :implicit
    expect(obj.blocks[1].tag).to eq :div
    expect(obj.blocks[1].lines.length).to eq 1
    expect(obj.blocks[1].lines[0]).to eq 'abc'
  end

  it "creates explicit block before and after stuff" do
    obj = described_class.new(["abc", "```", "something", "```", "def"])

    expect(obj.blocks.length).to eq 3
    
    expect(obj.blocks[0].type).to eq :implicit
    expect(obj.blocks[0].tag).to eq :div
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'abc'

    expect(obj.blocks[1].type).to eq :explicit
    expect(obj.blocks[1].tag).to eq :pre
    expect(obj.blocks[1].lines.length).to eq 1
    expect(obj.blocks[1].lines[0]).to eq 'something'

    expect(obj.blocks[2].type).to eq :implicit
    expect(obj.blocks[2].tag).to eq :div
    expect(obj.blocks[2].lines.length).to eq 1
    expect(obj.blocks[2].lines[0]).to eq 'def'
  end

  it "chains implicit blocks" do
    obj = described_class.new(["abc", "def"])

    expect(obj.blocks.length).to eq 1
    
    expect(obj.blocks[0].type).to eq :implicit
    expect(obj.blocks[0].tag).to eq :div
    expect(obj.blocks[0].lines.length).to eq 2
    expect(obj.blocks[0].lines[0]).to eq 'abc'
    expect(obj.blocks[0].lines[1]).to eq 'def'
  end

  it "separates implicit blocks separated by two newlines" do
    obj = described_class.new(["abc", "", "def"])

    expect(obj.blocks.length).to eq 2
    
    expect(obj.blocks[0].type).to eq :implicit
    expect(obj.blocks[0].tag).to eq :div
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'abc'

    expect(obj.blocks[1].type).to eq :implicit
    expect(obj.blocks[1].tag).to eq :div
    expect(obj.blocks[1].lines.length).to eq 1
    expect(obj.blocks[1].lines[0]).to eq 'def'
  end

  it "marks implicit blocks that have no indentation to be level 0" do
    obj = described_class.new(["line1"])

    expect(obj.blocks.length).to eq 1

    expect(obj.blocks[0].type).to eq :implicit
    expect(obj.blocks[0].tag).to eq :div
    expect(obj.blocks[0].level).to eq 0
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'line1'
  end

  it "marks implicit blocks that have 4 spaces of indentation to be level 1" do
    obj = described_class.new(["    indentedline"])

    expect(obj.blocks.length).to eq 1

    expect(obj.blocks[0].type).to eq :implicit
    expect(obj.blocks[0].tag).to eq :div
    expect(obj.blocks[0].level).to eq 1
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'indentedline'
  end

  it "separates indented implicit blocks from unindented blocks before" do
    obj = described_class.new(["unindented" , "    indented"])

    expect(obj.blocks.length).to eq 2

    expect(obj.blocks[0].type).to eq :implicit
    expect(obj.blocks[0].tag).to eq :div
    expect(obj.blocks[0].level).to eq 0
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'unindented'

    expect(obj.blocks[1].type).to eq :implicit
    expect(obj.blocks[1].tag).to eq :div
    expect(obj.blocks[1].level).to eq 1
    expect(obj.blocks[1].lines.length).to eq 1
    expect(obj.blocks[1].lines[0]).to eq 'indented'
  end

  it "separates indented implicit blocks from unindented blocks after" do
    obj = described_class.new(["    indented", "unindented"])

    expect(obj.blocks.length).to eq 2

    expect(obj.blocks[0].type).to eq :implicit
    expect(obj.blocks[0].tag).to eq :div
    expect(obj.blocks[0].level).to eq 1
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'indented'

    expect(obj.blocks[1].type).to eq :implicit
    expect(obj.blocks[1].tag).to eq :div
    expect(obj.blocks[1].level).to eq 0
    expect(obj.blocks[1].lines.length).to eq 1
    expect(obj.blocks[1].lines[0]).to eq 'unindented'
  end

  it "separates indented implicit blocks from unindented blocks before and after" do
    obj = described_class.new(["unindented1", "    indented", "unindented2"])

    expect(obj.blocks.length).to eq 3

    expect(obj.blocks[0].type).to eq :implicit
    expect(obj.blocks[0].tag).to eq :div
    expect(obj.blocks[0].level).to eq 0
    expect(obj.blocks[0].lines.length).to eq 1
    expect(obj.blocks[0].lines[0]).to eq 'unindented1'

    expect(obj.blocks[1].type).to eq :implicit
    expect(obj.blocks[1].tag).to eq :div
    expect(obj.blocks[1].level).to eq 1
    expect(obj.blocks[1].lines.length).to eq 1
    expect(obj.blocks[1].lines[0]).to eq 'indented'

    expect(obj.blocks[2].type).to eq :implicit
    expect(obj.blocks[2].tag).to eq :div
    expect(obj.blocks[2].level).to eq 0
    expect(obj.blocks[2].lines.length).to eq 1
    expect(obj.blocks[2].lines[0]).to eq 'unindented2'
  end
end
