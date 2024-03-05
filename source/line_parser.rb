require 'singleton'
require 'yaml'

class StateMachine
  attr_reader :current_state, :previous_state

  def initialize(state_table)
    # state a, transition b, state c
    # "a,b" => "c"
    @state_table = state_table
    @current_state = nil
    @previous_state = nil
  end

  def fromstates
    @state_table.map{|k,_| k.split(',')[0]}
  end

  def tostates
    @state_table.map {|_, v| v}
  end

  def states
    @states ||= Set.new(fromstates + tostates) 
  end

  def transitions
    @transitions ||= Set.new(@state_table.map{|k,_| k.split(',')[1]})
  end

  def transition(transition)
    prev = @current_state

    transition_key = "#{@current_state},#{transition}"

    if !transitions.include?(transition)

      if @current_state.nil?
        return :none
      else
        # normal char
        @current_state = nil
        return :close
      end
    end
    
    return_value = :inside
    if @current_state.nil?
      return_value = :open
    end

    @current_state = @state_table["#{@current_state},#{transition}"]

    return return_value

  ensure
    @previous_state = prev
  end
end

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
            link: { front: "[",   back: "]" },
            code: { front: "`",   back: "`" },
            math: { front: "[(",  back: ")]" },
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

class ParserWalker
  def initialize(text)
    @text = text
  end

  def parser_builder
    @parser_builder ||= ParserBuilder.instance
  end

  def spans
    result = []

    curtags = []
    (parse_positions.length - 1).times do |idx|
      p0 = parse_positions[idx][0]
      t0 = parse_positions[idx][1]
      p1 = parse_positions[idx+1][0]
      t1 = parse_positions[idx+1][1]

      if t0[:mode] == :start
        curtags += t0[:tag]
      end

      if t0[:mode] == :end
        curtags -= t0[:tag]
      end

      if t0[:x1] < t1[:x0]
        result << {styles: curtags.clone, text: @text[t0[:x1]..t1[:x0]] }
      end

    end
    result
  end

  def parse_positions
    @parse_positions ||= begin
      #get all positions, sort them
      poses = []

      poses << [0, {tag: [], mode: :start, x0: 0, x1: 0}]
      poses << [@text.length-1, {tag: [], mode: :end, x0: @text.length-1, x1: @text.length-1}]

      parse_info.each_with_index do |parse, idx|
        poses << [parse[:start], {tag: [parse[:tag]], mode: :start, x0: parse[:opener]-1, x1: parse[:start] }]
        poses << [parse[:end], {tag: [parse[:tag]], mode: :end, x0: parse[:end], x1: parse[:closer]+1 }]
      end

      poses.sort_by { |x| x[0]}
    end
  end

  def parse_info
    complete_parses.map do |parse|
      {
        **parse,
        opener: parse[:start] - ParserBuilder::SPAN_TYPES[parse[:tag]][:front].length,
        closer: parse[:end] + ParserBuilder::SPAN_TYPES[parse[:tag]][:back].length
      }
    end
  end

  def complete_parses
    @complete_parses ||= begin
      sm = StateMachine.new(parser_builder.state_table)

      active_tags = {}

      parses = []
      curblock = ""

      openpos = 0
      lastopenpos = 0

      (@text.split('') + ["end"]).each_with_index do |chr,pos|
        res = sm.transition(chr)

        curblock += chr if chr != 'end'

        if res == :open
          lastopenpos = openpos
          openpos = pos - 1
        end

        if res == :close
          tag_list = parser_builder.state_tag_table[sm.previous_state]

          if !tag_list.nil?
            tag_list.each do |tag, taginfo|
              if active_tags.key?(tag) && taginfo.include?(:end)
                startpos = active_tags[tag]
                parses << {tag: tag, start: startpos, end: openpos}
                curblock = curblock[-1]
                active_tags.delete(tag)

              elsif !active_tags.key?(tag) && taginfo.include?(:start)
                curblock = curblock[-1]
                active_tags[tag] = pos

              end

            end
          end
        end

        #puts "#{pos}: #{chr} - #{res} - #{active_tags} - #{curblock}"
        #puts "#{pos}: #{chr} - #{res} - #{sm.current_state},#{sm.previous_state} - #{parser_builder.state_tag_table[sm.previous_state]}"
      end

      parses
    end
  end

end

class LineParser

  def initialize(text)
    @text = text
  end

  def tree
    return {} if @text.nil?
  
    pw = ParserWalker.new(@text)

    #puts pw.parse_positions

    {
      array: pw.spans
    }
  end
end
