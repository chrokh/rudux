module Rudux
  class Combined
    def initialize hash
      @hash = hash
    end

    def reduce state, action
      @hash.keys.map do |key|
        reducer = @hash[key]
        if state.is_a? Hash
          substate = state[key]
        else
          substate = state.send(key)
        end
        reduced = reducer.reduce(substate, action)
        Hash[key, reduced]
      end.reduce({}, &:merge!)
    end
  end
end
