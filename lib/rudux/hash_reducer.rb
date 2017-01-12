require 'rudux/combined'

module Rudux
  class HashReducer

    def initialize reducer
      @subreducer = reducer
    end

    def reduce state, action
      unless state.is_a? Hash
        raise 'HashReducer not given hash'
      end

      state.keys.map do |key|
        result = @subreducer.reduce(state[key], action)

        if result.respond_to? :[]
          Hash[result[:id], result]
        else
          Hash[result.id, result]
        end
      end.reduce(&:merge!)
    end

  end
end
