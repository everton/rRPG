#-*- coding: utf-8 -*-

require 'test_helper'

class GameRandomlyPositioningCharacterTest < GameTestCase
  def setup
    @game   = Game.new dimensions: [20, 20]
    @player = PlayerCharacter.new 'Player'
  end

  def test_positioning_when_add_char_to_game
    mock_rand_with! 5 do
      @game.characters << @player
    end

    assert_on_position @player, 5, 5
  end
end
