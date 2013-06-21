#-*- coding: utf-8 -*-

require 'test_helper'

class AskCharacterForActionTest < GameTestCase
  def setup
    @player = MockedCharacter.new
    @enemy1 = MockedCharacter.new

    @game = Game.new dimensions: [15, 15]

    # #dead? must be called twice, before and other afer #turn_start!
    @player.expect :dead?, false
    @player.expect :dead?, false

    @enemy1.expect :dead?, false
    @enemy1.expect :dead?, false

    @player.expect :turn_start!, nil
    @enemy1.expect :turn_start!, nil

    @enemy1.expect :action, :pass,   [Hash]
    @enemy1.ignore_unexpected_calls!

    @game.characters << @player
    @game.characters << @enemy1
  end

  def test_game_asks_which_action_chars_want_to_do_and_let_him_do_it
    @player.expect :action, :know,   [Hash]

    @player.expect :know,    true,    [Hash]

    @game.run_a_turn

    assert @player.verify
    assert @enemy1.verify
  end

  def test_game_insists_asking_when_char_did_not_proper_respond_to_action
    @player.expect :action, :unknow, [Hash]
    @player.expect :action, :know,   [Hash]

    @player.expect :know,    true,    [Hash]

    @game.run_a_turn

    assert @player.verify
    assert @enemy1.verify
  end

  def test_current_scenario_passed_for_chars_when_asking_and_executing
    # for game dimensions, see setup... params passed on game start
    expected_scenario = {
      characters: [@player, @enemy1],
      tl: [0, 0], br: [14, 14]
    }

    @player.expect :action, :pass, [expected_scenario]
    @player.ignore_unexpected_calls!

    @game.run_a_turn

    assert @player.verify
    assert @enemy1.verify
  end
end
