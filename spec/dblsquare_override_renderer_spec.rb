describe DblsquareOverrideRenderer do
  describe "#url" do
    it "renders basic things as relative links" do
      obj = described_class.new(nil, {text: "page"})
      expect(obj.url).to eq "page/"
    end

    it "renders basic things as relative links and does not double the slash" do
      obj = described_class.new(nil, {text: "page/"})
      expect(obj.url).to eq "page/"
    end

    it "renders non alphanum characters with url encode" do
      obj = described_class.new(nil, {text: "*page*"})
      expect(obj.url).to eq "%2Apage%2A/"
    end

    it "recognizes anchors and does not urlencode the hash" do
      obj = described_class.new(nil, {text: "#sometitle"})
      expect(obj.url).to eq "#sometitle"
    end
  end

  describe "#text" do
    it "renders basic things" do
      obj = described_class.new(nil, {text: "page"})
      expect(obj.text).to eq "page"
    end

    it "renders basic things but hide the slash" do
      obj = described_class.new(nil, {text: "page/"})
      expect(obj.text).to eq "page"
    end

    it "renders non alphanum characters" do
      obj = described_class.new(nil, {text: "*page*"})
      expect(obj.text).to eq "*page*"
    end

    it "recognizes anchors and does not show the hash" do
      obj = described_class.new(nil, {text: "#sometitle"})
      expect(obj.text).to eq "sometitle"
    end

  end
end
