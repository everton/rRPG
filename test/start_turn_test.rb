#-*- coding: utf-8 -*-

require 'test_helper'

class StartTurnTest < GameTestCase
  def setup
    @player = MockedCharacter.new
    @enemy1 = MockedCharacter.new

    @game = Game.new

    @game.characters << @player
    @game.characters << @enemy1
  end

  def test_game_notify_all_alive_chars_that_turn_started
    # #dead? must be called twice, before and other afer #turn_start!
    @player.expect :dead?, false
    @player.expect :dead?, false

    @enemy1.expect :dead?, false
    @enemy1.expect :dead?, false

    @player.expect :turn_start!, nil
    @enemy1.expect :turn_start!, nil

    # The loop will need one action to proceed
    @player.expect :action?, :pass, [Hash]
    @enemy1.expect :action?, :pass, [Hash]

    @player.ignore_unexpected_calls!
    @enemy1.ignore_unexpected_calls!

    @game.run_a_turn

    assert @player.verify
    assert @enemy1.verify
  end

  def test_game_did_not_asks_nothing_for_dead_chars
    @player.expect :dead?, false
    @player.expect :dead?, false
    @player.expect :turn_start!, nil
    @player.expect :action?, :pass, [Hash]
    @player.ignore_unexpected_calls!

    @enemy1.expect :dead?, true

    @game.run_a_turn

    assert @player.verify
    assert @enemy1.verify
  end

  def test_game_did_not_asks_chars_dead_at_turn_start
    @player.expect :dead?, false
    @player.expect :dead?, false
    @player.expect :turn_start!, nil
    @player.expect :action?, :pass, [Hash]
    @player.ignore_unexpected_calls!

    # simulates a poisioned char that face death on turn start
    @enemy1.expect :dead?, false
    @enemy1.expect :turn_start!, nil do
      @enemy1.expect :dead?, true
    end

    @game.run_a_turn

    assert @player.verify
    assert @enemy1.verify
  end
end
