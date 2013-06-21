#-*- coding: utf-8 -*-

require 'test_helper'

class QuitingGameTest < GameTestCase
  def setup
    @player = MockedCharacter.new
    @enemy1 = MockedCharacter.new

    # #dead? must be called twice, before and other afer #turn_start!
    @player.expect :dead?, false
    @player.expect :dead?, false

    @player.expect :turn_start!, nil

    @game = Game.new

    @game.characters << @player
    @game.characters << @enemy1
  end

  def test_game_turn_just_return_null_when_quiting_to_stop_game_loop
    @player.expect :action, :quit, [Hash]

    refute @game.run_a_turn, ':quit action ignored'

    assert @player.verify
    assert @enemy1.verify # expects nothing to be called
  end

  def test_game_turn_return_non_nil_on_non_quiting_actions
    @enemy1.expect :dead?, false
    @enemy1.expect :dead?, false

    @player.expect :turn_start!, nil
    @enemy1.expect :turn_start!, nil

    # The loop will need one action to proceed
    @player.expect :action, :pass, [Hash]
    @enemy1.expect :action, :pass, [Hash]

    @player.expect :pass, nil, [Hash]
    @enemy1.expect :pass, nil, [Hash]

    assert @game.run_a_turn, 'should return true to keep the loop chain'

    assert @player.verify
    assert @enemy1.verify
  end
end
