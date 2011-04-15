#-*- coding: utf-8 -*-

class Game
  attr_accessor :characters
  
  def initialize(options = {})
    @characters = []
  end
  
  def run_a_turn
    @characters.each do |c|
      c.before_turn_start if c.respond_to? :before_turn_start
    end
  end
end
