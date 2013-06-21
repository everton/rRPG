#-*- coding: utf-8 -*-

require 'test_helper'

class RunGameTest < GameTestCase
  def setup
    @game = Game.new :dimensions => [5, 5]
    @game.define_singleton_method :run_a_turn do
      @turns ||= 0
      @turns  += 1

      @turns < 3 # false should stop the main loop
    end

    @player = PlayerCharacter.new 'Player'
    @enemy  = MockedCharacter.new

    @game.characters << @player
    @game.characters << @enemy
  end

  def test_run_game_main_loop
    3.times do # We will run 3 turns...
      @enemy.expect :dead?, false
      @enemy.expect :is_a?, false, [PlayerCharacter]
    end

    @game.run!

    assert @enemy.verify

    assert_equal 3, @game.instance_variable_get("@turns")
  end

  def test_try_run_without_characters
    assert_raises RuntimeError do
      Game.new.run!
    end
  end

  def test_player_is_winner_identification
    # Game needs to ask twice if char is or not a Player,
    # first to identify player chars and after to collect NPCs
    @enemy.expect :is_a?, false, [PlayerCharacter]
    @enemy.expect :is_a?, false, [PlayerCharacter]

    @enemy.expect :dead?, true

    assert_equal :player, @game.run!

    assert @enemy.verify
  end

  def test_cpu_is_winner_identification
    @enemy.expect :is_a?, false, [PlayerCharacter]

    @player.stub :dead?, true do
      assert_equal :cpu, @game.run!
    end
  end
end
