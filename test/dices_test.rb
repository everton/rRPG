#-*- coding: utf-8 -*-

require 'test_helper'

class DicesTest < GameTestCase
  def setup
    mock_rand_with! 2

    @dices = 3.d6
    @expected = 9

    # => 9 because #rand returning starts in 0 (zero)
    # so 2 in rand extends for 3 in dices...
  end

  def test_how_many_dices_you_have
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

  def test_dices_with_negative_modifier
    @dices -= 2
    assert_equal @expected - 2, @dices.roll
  end

  def test_dices_modifier_changing
    dices  = 3.d6 + 2
    dices += 5

    assert_equal 3.d6 + 7, dices
  end

  def test_dices_equality
    assert_equal 3.d6, 3.d6
    assert_equal 3.d6 + 7, 3.d6 + 7
    refute_equal 3.d6 - 5, 3.d6 + 7
  end

  def teardown
    unmock_rand!
  end
end
