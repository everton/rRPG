#-*- coding: utf-8 -*-

require_relative 'additional_tools'

require 'minitest/autorun'

require_relative 'support/mocked_character'

require 'game'

class GameTestCase < MiniTest::Unit::TestCase
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
