module InitCallback
  module AfterInit
    def self.included(base)
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def after_init(*callbacks, &block)
        callbacks << block if block_given?
        callbacks.each do |callback| # call it immediately
          invoke! callback
        end

        @after_init_callbacks ||= []
        @after_init_callbacks  += callbacks
        @after_init_callbacks.uniq!
      end

      def after_init_callbacks
        [*@after_init_callbacks] +
          self.class.after_init_callbacks
      end

      def invoke_after_init_callbacks!
        after_init_callbacks.each do |callback|
          invoke! callback
        end
      end

      def invoke!(callback)
        if callback.respond_to? :call
          callback.call(self)
        else
          send callback
        end
      end
    end

    module ClassMethods
      def after_init(*callbacks, &block)
        @after_init_callbacks ||= []

        callbacks << block if block_given?
        callbacks.each do |callback|
          unless after_init_callbacks.include? callback
            @after_init_callbacks << callback
          end
        end
      end

      def ancestor_after_init_callbacks
        return [] unless superclass.respond_to? :after_init_callbacks

        superclass.after_init_callbacks
      end

      def after_init_callbacks
        [*@after_init_callbacks] +
          ancestor_after_init_callbacks
      end
    end
  end
end
