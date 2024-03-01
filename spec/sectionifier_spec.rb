describe Sectionifier do
  it "groups implicit blocks into one section" do
    blocks = []
    b1 = Block.new
    b2 = Block.new

    blocks = [b1, b2]

    s = Sectionifier.new(blocks)

    expect(s.sections.length).to eq 1
    expect(s.sections[0].type).to eq :para
    expect(s.sections[0].blocks.length).to eq 2
  end

  it "groups implicit blocks into one section until a header" do
    blocks = []
    b1 = Block.new
    b2 = Block.new
    h1 = Block.new
    h1.tag = :header

    blocks = [b1, b2, h1]

    s = Sectionifier.new(blocks)

    expect(s.sections.length).to eq 2
    expect(s.sections[0].type).to eq :para
    expect(s.sections[0].blocks.length).to eq 2
    expect(s.sections[1].type).to eq :header
    expect(s.sections[1].blocks.length).to eq 1
  end

  it "groups all blocks after a header to a child section" do
    blocks = []
    b1 = Block.new
    b2 = Block.new
    h1 = Block.new
    h1.tag = :header
    b3 = Block.new
    b4 = Block.new

    blocks = [b1, b2, h1, b3, b4]

    s = Sectionifier.new(blocks)

    expect(s.sections.length).to eq 2
    expect(s.sections[0].type).to eq :para
    expect(s.sections[0].blocks.length).to eq 2
    expect(s.sections[1].type).to eq :header
    expect(s.sections[1].blocks.length).to eq 1
    expect(s.sections[1].children.length).to eq 1
    expect(s.sections[1].children[0].blocks.length).to eq 2
  end

  it "creates a child section for a header one level higher" do
    blocks = []
    b1 = Block.new

    h1 = Block.new
    h1.tag = :header
    h1.level = 1
    b2 = Block.new
    b3 = Block.new

    h2 = Block.new
    h2.tag = :header
    h2.level = 2
    b4 = Block.new
    b5 = Block.new

    blocks = [b1, h1, b2, b3, h2, b4, b5]

    s = Sectionifier.new(blocks)

    expect(s.sections.length).to eq 2
    expect(s.sections[0].type).to eq :para
    expect(s.sections[0].blocks.length).to eq 1

    expect(s.sections[1].type).to eq :header
    expect(s.sections[1].blocks.length).to eq 1
    expect(s.sections[1].children.length).to eq 2

    expect(s.sections[1].children[0].type).to eq :para
    expect(s.sections[1].children[0].blocks.length).to eq 2

    expect(s.sections[1].children[1].type).to eq :header
    expect(s.sections[1].children[1].blocks.length).to eq 1
    expect(s.sections[1].children[1].children.length).to eq 1

    expect(s.sections[1].children[1].children[0].type).to eq :para
    expect(s.sections[1].children[1].children[0].blocks.length).to eq 2
  end

  it "creates a child section and then cuts out on headers on the same level" do
    blocks = []
    b1 = Block.new

    h1 = Block.new
    h1.tag = :header
    h1.level = 1
    b2 = Block.new
    b3 = Block.new

    h2 = Block.new
    h2.tag = :header
    h2.level = 2
    b4 = Block.new
    b5 = Block.new

    h12 = Block.new
    h12.tag = :header
    h12.level = 1
    b6 = Block.new
    b7 = Block.new

    blocks = [b1, h1, b2, b3, h2, b4, b5, h12, b6, b7]

    s = Sectionifier.new(blocks)

    expect(s.sections.length).to eq 3
    expect(s.sections[0].type).to eq :para
    expect(s.sections[0].blocks.length).to eq 1

    expect(s.sections[1].type).to eq :header
    expect(s.sections[1].blocks.length).to eq 1
    expect(s.sections[1].children.length).to eq 2

    expect(s.sections[1].children[0].type).to eq :para
    expect(s.sections[1].children[0].blocks.length).to eq 2

    expect(s.sections[1].children[1].type).to eq :header
    expect(s.sections[1].children[1].blocks.length).to eq 1
    expect(s.sections[1].children[1].children.length).to eq 1

    expect(s.sections[1].children[1].children[0].type).to eq :para
    expect(s.sections[1].children[1].children[0].blocks.length).to eq 2

    expect(s.sections[2].type).to eq :header
    expect(s.sections[2].blocks.length).to eq 1
    expect(s.sections[2].children.length).to eq 1

    expect(s.sections[2].children[0].type).to eq :para
    expect(s.sections[2].children[0].blocks.length).to eq 2
  end

end
