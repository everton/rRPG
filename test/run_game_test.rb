#-*- coding: utf-8 -*-

require 'test_helper'

class RunGameTest < GameTestCase
  def setup
    @game = Game.new :dimensions => [5, 5]
    @game.fake :run_a_turn do
      @turns ||= 0
      @turns  += 1

      @turns < 5 # false should stop the main loop
    end

    @player = PlayerCharacter.new 'Player'
    @enemy  = MockedCharacter.new 'Enemy'

    @game.characters << @player
    @game.characters << @enemy
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
    @enemy.stub :dead?, true do
      assert_equal :player, @game.run!
    end
  end

  def test_cpu_is_winner_identification
    @player.stub :dead?, true do
      assert_equal :cpu, @game.run!
    end
  end
end
