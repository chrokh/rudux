require 'rudux/combined'

module Rudux
  class MutatingReducer

    def self.reduce states, action
      if states.is_a? Array
        reduce_array_of_states(states, action)
      elsif states.is_a? Hash
        reduce_hash_of_states(states, action)
      else
        reduce_single_state(states, action)
      end
    end

    def self.reduce_array_of_states states, action
      states.map do |state|
        reduce_single_state(state, action)
      end
    end

    def self.reduce_hash_of_states hash, action
      hash.map do |state|
        result = reduce_single_state(state[1], action)
        Hash[result.id, result]
      end.reduce(&:merge!)
    end

    def self.reduce_single_state state, action
      base = self.base.reduce(state, action)
      if self.respond_to? action.to_sym
        this = self.send(action.to_sym, state, action)
      else
        this = {}
      end
      merged = base.merge!(this)
      if merged.empty?
        state
      else
        # TODO: Everything but this line is essentially a copy of Rudux::Reducer
        state.mutate(merged)
      end
    end

    def self.base
      Rudux::Combined.new({})
    end

  end
end
