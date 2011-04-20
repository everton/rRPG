module Character
  module Modules
    def self.included(base)
      base.send :extend, ClassMethods
      base.send :include, SingletonMethods
    end

    module ClassMethods
      def have(mod_name, options = {})
        require_relative "modules/#{mod_name}"

        # TODO: create camelize and constantize methods
        mod_name = mod_name.to_s.split('_').
          collect(&:capitalize).join
        mod = Kernel.const_get(mod_name)

        include mod
        mod.init(self, options)
      end
    end

    module SingletonMethods
      def have(mod_name, options = {})
        require_relative "modules/#{mod_name}"

        # TODO: create camelize and constantize methods
        mod_name = mod_name.to_s.split('_').
          collect(&:capitalize).join
        mod = Kernel.const_get(mod_name)
        extend mod
        mod.init(self, options)
      end
    end

  end
end
