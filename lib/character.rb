#-*- coding: utf-8 -*-

class Character
  class << self
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

  def before_turn_start(*callbacks)
    @before_turn_start_callbacks ||= []
    @before_turn_start_callbacks  += callbacks
    @before_turn_start_callbacks.uniq!
  end

  def before_turn_start_callbacks
    [*@before_turn_start_callbacks] +
      self.class.before_turn_start_callbacks
  end

  def turn_start!
    before_turn_start_callbacks.each do |callback|
      send callback
    end
  end

  def dead?
    false # TODO: implement current logic based on HT attr
  end
end
