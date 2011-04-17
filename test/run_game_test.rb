#-*- coding: utf-8 -*-

require 'test_helper'

class RunGameTest < GameTestCase
  def setup
    @game = Game.new :dimensions => [5, 5]
    def @game.run_a_turn
      @turns ||= 0
      @turns  += 1

      @turns < 5 # false should stop the main loop
    end

    @player = PlayerCharacter.new('Player')
    @enemy1 = MockedCharacter.new('Enemy1')

    @game.characters << @player
    @game.characters << @enemy1
  end

  def test_run_game_main_loop
    @game.run!
    assert_equal 5, @game.instance_variable_get("@turns")
  end

  def test_try_run_without_characters
    @game.characters.clear
    assert_raises RuntimeError do
      @game.run!
    end
  end

  def test_player_is_winner_identification
    def @enemy1.dead?
      true
    end

    assert_equal :player, @game.run!
  end

  def test_cpu_is_winner_identification
    def @player.dead?
      true
    end

    assert_equal :cpu, @game.run!
  end
end
