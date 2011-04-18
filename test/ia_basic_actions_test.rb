#-*- coding: utf-8 -*-

require 'test_helper'

class IABasicActionsTest < GameTestCase
  def setup
    @player = PlayerCharacter.new 'Player'
    @enemy1 = NonPlayerCharacter.new 'CPU01'
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

  def test_full_attack_should_discounting_from_other_ht
    @player.x, @player.y = 2, 4

    def @enemy1.full_damage
      3
    end

    def @enemy1.attack_success?
      true
    end

    @enemy1.full_attack @scenario

    assert_equal 7, @player.ht
  end

  def test_dead
    @player.ht = 0
    assert  @player.dead?
    assert !@enemy1.dead?
  end
end
