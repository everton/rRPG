#-*- coding: utf-8 -*-

require_relative 'additional_tools' # try bundler, simplecov, etc

require_relative 'support/mocked_character'
require_relative 'support/stub'

require 'game'

require 'minitest/autorun'
class GameTestCase < MiniTest::Unit::TestCase
  include Directions

  def assert_action_called(action, char, times = 1)
    calls = char.called_actions[action]
    error = "#{char.name}#action? invoked #{calls} times."
    assert_equal(times, calls, error)
  end

  def assert_correct_scenario_on(char, game = @game)
    others = game.characters.reject{|c| c == char }

    assert_equal({others: others, tl: [0, 0], br: game.limits},
                 char.instance_variable_get("@scenario"))
  end

  def assert_on_position(char, x, y)
    assert_equal x, char.x, 'X'
    assert_equal y, char.y, 'Y'
  end

  def mock_rand_with!(n, &block)
    Kernel.module_eval do
      alias original_rand rand
      define_method :rand do |x|
        n
      end
    end

    if block_given?
      yield
      unmock_rand!
    end
  end

  def unmock_rand!
    Kernel.module_eval do
      alias rand original_rand
    end
  end
end
