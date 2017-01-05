module Rudux
  class Store
    attr_reader :state

    def initialize reducer, state
      @reducer = reducer
      @state   = state
    end

    def dispatch actions
      Array(actions).each do |action|
        @state = @reducer.reduce(@state, action)
      end
    end

    def reset state
      @state = state
    end

    def select selector
      selector.select(@state)
    end

  end
end
