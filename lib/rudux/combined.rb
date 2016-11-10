module Rudux
  class Combined
    def initialize hash
      @hash = hash
    end

    def reduce state, action
      @hash.keys.map do |key|
        reducer = @hash[key]
        reduced = reducer.reduce(state.send(key), action)
        Hash[key, reduced]
      end.reduce({}, &:merge!)
    end
  end
end
