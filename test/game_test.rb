#!/usr/bin/env ruby
#-*- coding: utf-8 -*-

require 'minitest/autorun'
require 'game'

class GameTest < MiniTest::Unit::TestCase
  def setup
    @game   = Game.new :dimensions => [5, 5]

    @player = MockedCharacter.new('Player')
    @enemy1 = MockedCharacter.new('Enemy1')

    @game.characters << @player
    @game.characters << @enemy1
  end

  def test_call_before_turn_start_callback_on_all_characters
    @game.run_a_turn
    @game.characters.each do |char|
      assert_action_called(:before_turn_start, char)
    end
  end

  def test_ask_which_action_to_run_on_all_characters
    @game.run_a_turn
    @game.characters.each do |char|
      assert_action_called(:action?, char, 2)
    end
  end

  def test_call_action_on_all_characters
    @game.run_a_turn
    @game.characters.each do |char|
      assert_action_called(:full_attack, char, 1)
    end
  end

  def test_call_action_params
    def @player.full_attack(world = {})
      @enemies  = world[:enemies]
      @tl_limit = world[:tl]
      @br_limit = world[:br]
    end

    @game.run_a_turn

    assert_equal([@enemy1], @player.
                 instance_variable_get("@enemies"))

    assert_equal([0, 0], @player.
                 instance_variable_get("@tl_limit"))

    assert_equal([4, 4], @player.
                 instance_variable_get("@br_limit"))
  end

  def test_know_action_types
    assert_equal([:move, :full_attack, :move_and_attack],
                 @game.know_actions)
  end

  private
  def assert_action_called(action, char, times = 1)
    calls = char.called_actions[action]
    error = "#{char.name}#action? invoked #{calls} times."
    assert_equal(times, calls, error)
  end

  class MockedCharacter
    attr_accessor :called_actions, :name

    def initialize(name)
      @name, @called_actions = name, Hash.new(0)
    end

    def method_missing(sym, *args, &block)
      @called_actions[sym] += 1
    end

    def action?
      @called_actions[:action?] += 1
      :full_attack if @called_actions[:action?] > 1
    end
  end
end
