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

    # whenever we see an unknown transition, we define it as a normal character
    if !transitions.include?(transition)

      if @current_state.nil?
        # if we are not already in a state we just dont change
        return :none
      else
        # if we were halfway through a span definition, we close it.
        @current_state = nil
        return :close
      end
    end
    
    # when its a span defined with multiple characters we say we are inside it, or
    # open it if its the first character
    return_value = :inside
    if @current_state.nil?
      return_value = :open
    end

    # when we suddenly transition to a different span or we don't expect it we close
    # the span right now.
    if !@state_table.key?(transition_key)
      @current_state = nil
      return_value = :close
    end

    @current_state = @state_table["#{@current_state},#{transition}"]

    return return_value

  ensure
    @previous_state = prev
  end
end
