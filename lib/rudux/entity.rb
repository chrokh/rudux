require 'securerandom'

module Rudux
  class Entity
    attr_reader :id

    def initialize hash={}
      unless hash.has_key? :id
        @id = SecureRandom.uuid.freeze
      end
      hash.each do |key, value|
        value.freeze
        instance_variable_set("@#{key}", value)
      end
    end

    def to_hash
      Hash[instance_variables.map{ |key|
        [key[1..-1].to_sym, instance_variable_get(key)]
      }]
    end

    def copy hash={}
      if hash.empty?
        self
      else
        self.class.new to_hash.merge! hash
      end
    end

    def mutate hash={}
      if hash.empty?
        self
      else
        hash.keys.each do |key|
          instance_variable_set("@#{key}", hash[key])
        end
        self
      end
    end

  end
end
