#-*- coding: utf-8 -*-

class Game
  attr_accessor :characters

  def initialize(options = {})
    @characters = []
    @dimensions = options[:dimensions] || [10, 10]
    @limits     = [@dimensions.first - 1,
                   @dimensions.last  - 1]
  end

  def know_actions
    [:move, :full_attack, :move_and_attack]
  end

  def run_a_turn
    @characters.each do |c|
      c.before_turn_start

      world = scenario_for(c)
      action = c.action?(world) until know_actions.include? action

      c.send(action, world)
    end
  end

  private
  def scenario_for(character)
    others = @characters.select{|c| c != character }
    {:others => others, :tl => [0, 0], :br => @limits}
  end
end
