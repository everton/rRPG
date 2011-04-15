#-*- coding: utf-8 -*-

class Game
  attr_accessor :characters

  def initialize(options = {})
    @characters = []
  end

  def run_a_turn
    @characters.each do |c|
      c.before_turn_start

      action = c.action? until know_actions.include? action
    end
  end

  def know_actions
    [:move, :full_attack, :move_and_attack]
  end
end
