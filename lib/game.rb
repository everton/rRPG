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
    [:quit, :move, :full_attack, :move_and_attack]
  end

  def run!
    raise 'EmptyCharactersList' if @characters.empty?

    return :cpu if player_character.dead?
    return :player if computer_characters.all? &:dead?

    run! if run_a_turn
  end

  def run_a_turn
    @characters.each do |c|
      c.before_turn_start

      world = scenario_for(c)
      action = c.action?(world) until know_actions.include? action

      return nil if action == :quit

      c.send(action, world)
    end
  end

  private
  def player_character
    @player_character ||= @characters.select { |char|
      char.is_a? PlayerCharacter
    }.first
  end

  def computer_characters
    @computer_characters ||= @characters.reject { |char|
      char.is_a? PlayerCharacter
    }
  end

  def scenario_for(character)
    others = @characters.select{|c| c != character }
    {:others => others, :tl => [0, 0], :br => @limits}
  end
end
