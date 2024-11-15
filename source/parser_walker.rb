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

      if t0[:x1] <= t1[:x0]
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

      # we step through each character
      (@text.split('') + ["end"]).each_with_index do |chr,pos|
        res = sm.transition(chr)

        inside_exclusive = active_tags.any? { |k,v| ParserBuilder::SPAN_TYPES[k][:exclusive] }

        curblock += chr if chr != 'end'

        # this result is the opening of a span
        if res == :open
          lastopenpos = openpos
          openpos = pos - 1
        end

        # this result is the closing of a span
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
                openpos = pos - 1 # set the openpos in case we close consecutively and end with -1

                if !inside_exclusive
                  # if we are inside an exclusive tag, we consider all transitions normal
                  # and disable the state machine temporarily until the result is the end
                  # of the exclusive tag
                  active_tags[tag] = pos
                end

              end

            end
          end
        end

        #puts "#{pos}: #{chr} - #{res} - #{active_tags} - #{curblock}, #{lastopenpos}, #{openpos}"
        #puts "#{pos}: #{chr} - #{res} - #{sm.current_state},#{sm.previous_state} - #{parser_builder.state_tag_table[sm.previous_state]}"
      end

      #p parses
      parses
    end
  end
end
