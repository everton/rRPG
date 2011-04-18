#-*- coding: utf-8 -*-

require 'test_helper'

class IABasicActionsTest < GameTestCase
  def setup
    @player = PlayerCharacter.new 'Player'
    @enemy1 = NonPlayerCharacter.new 'CPU01', :ht => 10
    @enemy1.x, @enemy1.y = 3, 3

    @scenario = {
      :others => [@player],
      :tl => [0, 0], :br => [10, 10]
    }
  end

  def test_close_move_action
    @player.x, @player.y = 4, 5 # =~ 2.24u of distance

    @enemy1.move @scenario

    assert_equal 4, @enemy1.x
    assert_equal 5, @enemy1.y
  end

  def test_far_move_action
    @player.x, @player.y = 2, 10 # =~ 7.07u of distance

    @enemy1.move @scenario

    assert_equal 3, @enemy1.x
    assert_equal 7, @enemy1.y
  end
end
