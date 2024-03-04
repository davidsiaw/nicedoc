describe LineParser do
  it "parses line bold" do
    lp = described_class.new('*hello*')

    expect(lp.tree[:array]).to eq([
      {
        styles: [:bold],
        text: 'hello'
      }
    ])
  end

  it "parses text after" do
    lp = described_class.new('*hello* world')

    expect(lp.tree[:array]).to eq([
      {
        styles: [:bold],
        text: 'hello'
      },
      {
        styles: [],
        text: ' world'
      }
    ])
  end

  it "parses text before" do
    lp = described_class.new('hello *world*')

    expect(lp.tree[:array]).to eq([
      {
        styles: [],
        text: 'hello '
      },
      {
        styles: [:bold],
        text: 'world'
      }
    ])
  end

  it "does not parse incomplete" do
    lp = described_class.new('hello world*')

    expect(lp.tree[:array]).to eq([
      {
        styles: [],
        text: 'hello world*'
      }
    ])
  end

  it "does not parse incomplete from left" do
    lp = described_class.new('*hello *world*')

    expect(lp.tree[:array]).to eq([
      {
        styles: [:bold],
        text: 'hello '
      },
      {
        styles: [],
        text: 'world*'
      }
    ])
  end

  it "parses line very bold" do
    lp = described_class.new('**hello**')

    expect(lp.tree[:array]).to eq([
      {
        styles: [:verybold],
        text: 'hello'
      }
    ])
  end

  it "parses line super bold" do
    lp = described_class.new('***hello***')

    expect(lp.tree[:array]).to eq([
      {
        styles: [:superbold],
        text: 'hello'
      }
    ])
  end

  it "parses overlapping text" do
    lp = described_class.new('*hel/lo*world/')

    expect(lp.tree[:array]).to eq([
      {
        styles: [:bold],
        text: 'hel'
      },
      {
        styles: [:bold, :italics],
        text: 'lo'
      },
      {
        styles: [:italics],
        text: 'world'
      }
    ])
  end
end