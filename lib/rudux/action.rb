module Rudux
  class Action

    def to_sym
      @@sym_cache ||= {}
      @@sym_cache[self.class.name] ||= self.class.name.
        split('::').last.
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase.to_sym
    end

  end
end
