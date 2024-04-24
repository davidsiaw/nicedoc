require 'singleton'
class ParserBuilder
  include Singleton

  SPAN_TYPES = {
            bold: { front: "*",   back: "*" },
        verybold: { front: "**",  back: "**" },
       superbold: { front: "***", back: "***" },
         italics: { front: "/",   back: "/" },
       underline: { front: "_",   back: "_" },
   strikethrough: { front: "--",  back: "--" },
        overline: { front: "^",   back: "^" },
          square: { front: "[",   back: "]" },
          parens: { front: "(",   back: ")" },
            code: { front: "`",   back: "`" },
       dblsquare: { front: "[[",  back: "]]" },
        sqparens: { front: "[(",  back: ")]" },
  }

  def build!
    state_table = {}
    state_tag_table = {}

    SPAN_TYPES.each do |name, info|
      prevstate = nil
      info[:front].split('').each do |chr|
        statekey = "s#{state_table.length}"
        state_table["#{prevstate},#{chr}"] ||= statekey

        prevstate = state_table["#{prevstate},#{chr}"]
      end

      state_tag_table["#{prevstate}"] ||= {}
      state_tag_table["#{prevstate}"][name] ||= Set.new
      state_tag_table["#{prevstate}"][name] << :start

      prevstate = nil
      info[:back].split('').each do |chr|
        statekey = "s#{state_table.length}"
        state_table["#{prevstate},#{chr}"] ||= statekey

        prevstate = state_table["#{prevstate},#{chr}"]
      end

      state_tag_table["#{prevstate}"] ||= {}
      state_tag_table["#{prevstate}"][name] ||= Set.new
      state_tag_table["#{prevstate}"][name] << :end
    end

    @state_table = state_table
    @state_tag_table = state_tag_table
  end

  def state_table
    build! if @state_table.nil?
    @state_table
  end

  def state_tag_table
    build! if @state_tag_table.nil?
    @state_tag_table
  end
end
