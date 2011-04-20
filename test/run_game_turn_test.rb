#-*- coding: utf-8 -*-

require 'test_helper'

class RunGameTurnTest < GameTestCase
  def setup
    @game   = Game.new :dimensions => [5, 5]

    @player = MockedCharacter.new('Player')
    @enemy  = MockedCharacter.new('Enemy1')

    @game.characters << @player
    @game.characters << @enemy

    @game.run_a_turn
  end

  def test_call_before_turn_start_callback_on_all_characters
    @game.characters.each do |char|
      assert_action_called(:turn_start!, char)
    end
  end

  def test_ask_which_action_to_run_on_all_characters
    @game.characters.each do |char|
      assert_action_called(:action?, char, 2)
      assert_correct_scenario_on char
    end
  end

  def test_call_action_on_all_characters
    @game.characters.each do |char|
      assert_action_called(:full_attack, char)
      assert_correct_scenario_on char
    end
  end

  def test_call_action_params
    assert_correct_scenario_on @enemy
    assert_correct_scenario_on @player
  end

  def test_run_a_turn_return_ok_in_normal_turns
    assert @game.run_a_turn, 'should return true to keep the loop chain'
  end

  def test_stop_game_if_quit_action_called
    @player.stub :action? do |scenario|
      :quit
    end

    refute @game.run_a_turn, ':quit action ignored'
  end
end
