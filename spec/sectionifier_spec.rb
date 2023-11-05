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
    h1.type = :header

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
    h1.type = :header
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
    h1.type = :header
    h1.level = 1
    b2 = Block.new
    b3 = Block.new

    h2 = Block.new
    h2.type = :header
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
    h1.type = :header
    h1.level = 1
    b2 = Block.new
    b3 = Block.new

    h2 = Block.new
    h2.type = :header
    h2.level = 2
    b4 = Block.new
    b5 = Block.new

    h12 = Block.new
    h12.type = :header
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


  it "creates a section for ordered lists containing children for each entry" do
    blocks = []
    o1 = Block.new
    o1.tag = :ol
    o2 = Block.new
    o2.tag = :ol
    o3 = Block.new
    o3.tag = :ol

    blocks = [o1, o2, o3]

    s = Sectionifier.new(blocks)

    expect(s.sections.length).to eq 1
    expect(s.sections[0].type).to eq :ol
    expect(s.sections[0].blocks.length).to eq 0
    expect(s.sections[0].children.length).to eq 3

    expect(s.sections[0].children[0].type).to eq :li
    expect(s.sections[0].children[0].blocks.length).to eq 1

    expect(s.sections[0].children[1].type).to eq :li
    expect(s.sections[0].children[1].blocks.length).to eq 1

    expect(s.sections[0].children[2].type).to eq :li
    expect(s.sections[0].children[2].blocks.length).to eq 1
  end


  it "creates a section for unordered lists containing children for each entry" do
    blocks = []
    u1 = Block.new
    u1.tag = :ul
    u2 = Block.new
    u2.tag = :ul
    u3 = Block.new
    u3.tag = :ul

    blocks = [u1, u2, u3]

    s = Sectionifier.new(blocks)

    expect(s.sections.length).to eq 1
    expect(s.sections[0].type).to eq :ul
    expect(s.sections[0].blocks.length).to eq 0
    expect(s.sections[0].children.length).to eq 3

    expect(s.sections[0].children[0].type).to eq :li
    expect(s.sections[0].children[0].blocks.length).to eq 1

    expect(s.sections[0].children[1].type).to eq :li
    expect(s.sections[0].children[1].blocks.length).to eq 1

    expect(s.sections[0].children[2].type).to eq :li
    expect(s.sections[0].children[2].blocks.length).to eq 1
  end

  it "creates sections for nested unordered lists" do
    blocks = []
    u01 = Block.new
    u01.tag = :ul
    u01.level = 0
    u02 = Block.new
    u02.tag = :ul
    u02.level = 0
    u11 = Block.new
    u11.tag = :ul
    u11.level = 1
    u12 = Block.new
    u12.tag = :ul
    u12.level = 1

    blocks = [u01, u02, u11, u12]

    # - u01
    # - u02
    #   - u11
    #   - u12

    s = Sectionifier.new(blocks)

    expect(s.sections.length).to eq 1
    expect(s.sections[0].type).to eq :ul
    expect(s.sections[0].blocks.length).to eq 0
    expect(s.sections[0].children.length).to eq 2

    expect(s.sections[0].children[0].type).to eq :li
    expect(s.sections[0].children[0].blocks.length).to eq 1
    expect(s.sections[0].children[0].children.length).to eq 0

    expect(s.sections[0].children[1].type).to eq :li
    expect(s.sections[0].children[1].blocks.length).to eq 1
    expect(s.sections[0].children[1].children.length).to eq 1

    expect(s.sections[0].children[1].children[0].type).to eq :ul
    expect(s.sections[0].children[1].children[0].blocks.length).to eq 0
    expect(s.sections[0].children[1].children[0].children.length).to eq 2

    expect(s.sections[0].children[1].children[0].children[0].type).to eq :li
    expect(s.sections[0].children[1].children[0].children[0].blocks.length).to eq 1

    expect(s.sections[0].children[1].children[0].children[1].type).to eq :li
    expect(s.sections[0].children[1].children[0].children[1].blocks.length).to eq 1
  end


  it "creates a section for nested unordered lists under header" do
    blocks = []

    h1 = Block.new
    h1.type = :header

    u01 = Block.new
    u01.tag = :ul
    u01.level = 0
    u02 = Block.new
    u02.tag = :ul
    u02.level = 0
    u11 = Block.new
    u11.tag = :ul
    u11.level = 1
    u12 = Block.new
    u12.tag = :ul
    u12.level = 1


    blocks = [h1, u01, u02, u11, u12]

    s = Sectionifier.new(blocks)

    expect(s.sections.length).to eq 1
    expect(s.sections[0].type).to eq :header
    expect(s.sections[0].blocks.length).to eq 1
    expect(s.sections[0].children.length).to eq 1

    expect(s.sections[0].children[0].type).to eq :ul
    expect(s.sections[0].children[0].blocks.length).to eq 0
    expect(s.sections[0].children[0].children.length).to eq 2

    expect(s.sections[0].children[0].children[0].type).to eq :li
    expect(s.sections[0].children[0].children[0].blocks.length).to eq 1
    expect(s.sections[0].children[0].children[0].children.length).to eq 0

    expect(s.sections[0].children[0].children[1].type).to eq :li
    expect(s.sections[0].children[0].children[1].blocks.length).to eq 1
    expect(s.sections[0].children[0].children[1].children.length).to eq 1

    expect(s.sections[0].children[0].children[1].children[0].type).to eq :ul
    expect(s.sections[0].children[0].children[1].children[0].blocks.length).to eq 0
    expect(s.sections[0].children[0].children[1].children[0].children.length).to eq 2

    expect(s.sections[0].children[0].children[1].children[0].children[0].type).to eq :li
    expect(s.sections[0].children[0].children[1].children[0].children[0].blocks.length).to eq 1
    expect(s.sections[0].children[0].children[1].children[0].children[0].children.length).to eq 0

    expect(s.sections[0].children[0].children[1].children[0].children[1].type).to eq :li
    expect(s.sections[0].children[0].children[1].children[0].children[1].blocks.length).to eq 1
    expect(s.sections[0].children[0].children[1].children[0].children[1].children.length).to eq 0
  end
end
