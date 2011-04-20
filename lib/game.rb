#-*- coding: utf-8 -*-

require_relative 'support'
require_relative 'character'

class Game
  attr_accessor :characters, :dimensions

  def initialize(options = {})
    @characters = []
    @dimensions = options[:dimensions] || [10, 10]
  end

  def run!
    raise 'EmptyCharactersList' if @characters.empty?

    return :cpu if player_character.dead?
    return :player if computer_characters.all? &:dead?

    run! if run_a_turn
  end

  def run_a_turn
    @characters.each do |c|
      c.turn_start!

      world = scenario_for(c)

      action = c.action?(world) until action and
        c.respond_to? action

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
    {
      :others => others, :tl => [0, 0],
      :br => [@dimensions.first - 1, @dimensions.last - 1]
    }
  end
end
