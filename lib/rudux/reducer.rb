require 'rudux/combined'

module Rudux
  class Reducer

    def self.reduce states, action
      if states.is_a? Array
        reduce_array_of_states(states, action)
      else
        reduce_single_state(states, action)
      end
    end

    def self.reduce_array_of_states states, action
      states.map do |state|
        reduce_single_state(state, action)
      end
    end

    def self.reduce_single_state state, action
      base = self.base.reduce(state, action)
      unless action.respond_to? :to_sym
        puts "Action #{action.inspect} received to_sym"
      end
      if self.respond_to? action.to_sym
        this = self.send(action.to_sym, state, action)
      else
        this = {}
      end
      merged = base.merge!(this)
      if merged.empty?
        state
      else
        if state.respond_to? :copy
          # oop style
          state.copy(merged)
        else
          # hash style
          merged
        end
      end
    end

    def self.base
      Rudux::Combined.new({})
    end

  end
end
