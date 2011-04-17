#-*- coding: utf-8 -*-

require 'game'
require 'character'
require 'player_character'

require 'minitest/autorun'

class GameTestCase < MiniTest::Unit::TestCase
  def assert_action_called(action, char, times = 1)
    calls = char.called_actions[action]
    error = "#{char.name}#action? invoked #{calls} times."
    assert_equal(times, calls, error)
  end
end

class MockedCharacter
  attr_accessor :called_actions, :name

  def initialize(name)
    @name, @called_actions = name, Hash.new(0)
  end

  def method_missing(sym, *args, &block)
    @called_actions[sym] += 1
  end

  def action?(scenario = {})
    @scenario = scenario
    @called_actions[:action?] += 1
    :full_attack if @called_actions[:action?] > 1
  end

  def dead?
    false
  end
end
