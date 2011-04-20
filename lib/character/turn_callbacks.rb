module TurnCallback
  module BeforeStart
    def self.included(base)
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def before_turn_start(*callbacks)
        @before_turn_start_callbacks ||= []
        @before_turn_start_callbacks  += callbacks
        @before_turn_start_callbacks.uniq!
      end

      def before_turn_start_callbacks
        [*@before_turn_start_callbacks] +
          self.class.before_turn_start_callbacks
      end
    end

    module ClassMethods
      def before_turn_start(*callbacks)
        @before_turn_start_callbacks ||= []
        callbacks.each do |callback|
          unless before_turn_start_callbacks.include? callback
            @before_turn_start_callbacks << callback
          end
        end
      end

      def ancestor_before_turn_start_callbacks
        return [] unless superclass.respond_to? :before_turn_start_callbacks

        superclass.before_turn_start_callbacks
      end

      def before_turn_start_callbacks
        [*@before_turn_start_callbacks] +
          ancestor_before_turn_start_callbacks
      end
    end
  end
end
