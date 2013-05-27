#-*- coding: utf-8 -*-

require 'test_helper'

using Dice

class DiceTest < GameTestCase
  def setup
    mock_rand_with! 2

    @dice = 3.d6
    @expected = 9

    # => 9 because #rand returning starts in 0 (zero)
    # so 2 in rand extends for 3 in dice...
  end

  def test_how_many_dice_you_have
    assert_equal 3, 3.d6.size
    assert_equal 4, 4.d6.size
  end

  def test_roll
    # TODO: dice is plural for die...
    assert_equal @expected, @dice.roll
  end

  def test_dice_with_modifier
    @dice += 2
    assert_equal @expected + 2, @dice.roll
  end

  def test_dice_with_negative_modifier
    @dice -= 2
    assert_equal @expected - 2, @dice.roll
  end

  def test_dice_modifier_changing
    dice  = 3.d6 + 2
    dice += 5

    assert_equal 3.d6 + 7, dice
  end

  def test_dice_equality
    assert_equal 3.d6, 3.d6
    assert_equal 3.d6 + 7, 3.d6 + 7
    refute_equal 3.d6 - 5, 3.d6 + 7
  end

  def test_dice_inspect
    assert_equal '3d6', 3.d6.inspect
    assert_equal '3d6+7', (3.d6 + 7).inspect
    assert_equal '3d6-5', (3.d6 - 5).inspect
  end

  def teardown
    unmock_rand!
  end
end
