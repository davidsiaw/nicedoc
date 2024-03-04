class LineParser
  SPAN_TYPES = {
            bold: { front: "*",   back: "*" },
        verybold: { front: "**",  back: "**" },
       superbold: { front: "***", back: "***" },
         italics: { front: "/",   back: "/" },
       underline: { front: "_",   back: "_" },
   strikethrough: { front: "--",  back: "--" },
        overline: { front: "^",   back: "^" },
            link: { front: "[",   back: "]" },
            code: { front: "`",   back: "`" },
            math: { front: "[(",  back: ")]" },
  }

  def initialize(text)
    @text = text
  end

  def tree
    return {} if @text.nil?

    charposes = {}

    @text.split('').each_with_index do |chr, index|
      if WATCHCHARS.include?(chr)
        charposes[chr] ||= []
        charposes[chr] << index
      end
    end

    {
      charposes: charposes,
    }
  end
end
