#-*- coding: utf-8 -*-

require_relative 'support'
require_relative 'character'

class Game
  attr_accessor :characters, :dimensions

  def initialize(options = {})
    @characters = CharacterList.for_game self
    @dimensions = options[:dimensions] || [20, 20]
  end

  def run!
    raise 'Empty characters list' if @characters.empty?

    return :cpu if player_character.dead?
    return :player if computer_characters.all? &:dead?

    run! if run_a_turn
  end

  def run_a_turn
    @characters.each do |c|
      next if c.dead?

      c.turn_start!

      next if c.dead?

      world = scenario_for(c)

      action = c.action(world) until action and
        c.respond_to?(action) or action == :quit

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
    { characters: @characters, tl: [0, 0],
      br: [@dimensions.first - 1, @dimensions.last - 1] }
  end

  class CharacterList < Array
    attr_accessor :game

    def self.for_game(game)
      new.tap do |character_list|
        character_list.game = game
      end
    end

    def <<(char)
      char.x ||= rand(@game.dimensions.first)
      char.y ||= rand(@game.dimensions.last )

      super(char)
    end
  end
end
