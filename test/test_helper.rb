#-*- coding: utf-8 -*-

require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
  add_filter "/vendor/"
  add_group "Support", "/support"
end

require 'minitest/autorun'
ENV['RACK_ENV'] = 'test'

require 'bundler'
Bundler.setup
Bundler.require(:default, :test)

require 'minitest/autorun'
require 'support'
require 'game'
require 'character'
require 'player_character'
require 'non_player_character'

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

Object.class_eval do
  def stub(method_name, options = {}, &block)
    proc = block || Proc.new do
      options[:return]
    end

    if self.is_a? Class
      define_method method_name, &proc
    else
      define_singleton_method method_name, &proc
    end
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
