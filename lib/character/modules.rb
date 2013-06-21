module Character
  module Modules
    def self.included(base)
      base.send :extend,      ClassMethods
      base.send :include, SingletonMethods
    end

    module AutoMagickInclusion
      def automagicaly_require(mod_name)
        require_relative "modules/#{mod_name}"

        # TODO: create camelize and constantize methods
        mod_name = mod_name.to_s.split('_').
          collect(&:capitalize).join

        Kernel.const_get(mod_name)
      end
    end

    module ClassMethods
      include Character::Modules::AutoMagickInclusion

      def have(mod_name, options = {})
        mod = automagicaly_require(mod_name)

        include mod
        mod.init(self, options)
      end
    end

    module SingletonMethods
      include Character::Modules::AutoMagickInclusion

      def have(mod_name, options = {})
        mod = automagicaly_require(mod_name)

        extend mod
        mod.init(self, options)
      end
    end
  end
end
