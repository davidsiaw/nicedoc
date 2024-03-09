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
