#-*- coding: utf-8 -*-

require 'test_helper'

class DicesTest < GameTestCase
  def setup
    Kernel.module_eval do
      alias original_rand rand
      def rand(n); 2; end
    end

    @dices = 3.d6

    # => 9 because rand returning starts in 0 (zero)
    # so 2 in mock extends for 3...
    @expected = 9
  end

  def test_return_of_dices
    assert_equal 3, 3.d6.size
    assert_equal 4, 4.d6.size
  end

  def test_roll
    assert_equal @expected, @dices.roll
  end

  def test_dices_with_modifier
    @dices += 2
    assert_equal @expected + 2, @dices.roll
  end

  def teardown
    Kernel.module_eval do
      alias rand original_rand
    end
  end
end