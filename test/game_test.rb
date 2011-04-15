#!/usr/bin/env ruby
#-*- coding: utf-8 -*-

require 'minitest/autorun'
require 'game'

class GameTest < MiniTest::Unit::TestCase
  def setup
    @game   = Game.new :dimensions => [5, 5]

    @player = MockedCharacter.new
    @enemy1 = MockedCharacter.new

    @game.characters << @player
    @game.characters << @enemy1
  end

  def test_call_before_turn_start_callback_on_all_characters
    mock(:before_turn_start, MockedCharacter) do
      @called_actions[:before_turn_start] += 1
    end

    @game.run_a_turn

    assert_equal(1, @player.called_actions[:before_turn_start],
                 '#before_turn_start never invoked on Player')
    assert_equal(1, @enemy1.called_actions[:before_turn_start],
                 '#before_turn_start never invoked on NPC')
  end

  private
  def mock(method, o, &block)
    o.define_singleton_method(method, &block) unless o.is_a? Class

    o.class_eval do
      define_method(method, &block)
    end
  end

  class MockedCharacter
    attr_accessor :called_actions

    def initialize
      @called_actions = Hash.new(0)
    end

    def do(action, *args)
      @called_actions[action] += 1
    end

    def dead?
      false
    end
  end
end
