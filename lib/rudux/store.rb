module Rudux
  class Store
    attr_reader :state

    def initialize reducer, state
      @reducer = reducer
      @state   = state
    end

    def dispatch action
      @state = @reducer.reduce(@state, action)
    end

    def select selector
      selector.select(@state)
    end

  end
end
