#-*- coding: utf-8 -*-

require 'test_helper'

class IAWhichActionChooseTest < GameTestCase
  def setup
    @player = PlayerCharacter.new 'Player'
    @enemy1 = NonPlayerCharacter.new 'CPU01'
    @enemy1.x, @enemy1.y = 3, 3

    @scenario = {
      :others => [@player],
      :tl => [0, 0], :br => [10, 10]
    }
  end

  def test_choose_full_attack_when_close_to_player
    neighbors = [[2, 2], [3, 2], [4, 2],
                 [2, 3],         [4, 3],
                 [2, 4], [3, 4], [4, 4]]

    neighbors.each do |x, y|
      @player.x, @player.y = x, y
      assert_equal :full_attack, @enemy1.action?(@scenario)
    end
  end

  def test_choose_move_and_attack_case_at_medium_distance
    @player.x, @player.y = 5, 5
    assert_equal :move_and_attack, @enemy1.action?(@scenario)
  end

  def test_choose_move_if_far_away
    @player.x, @player.y = 7, 3
    assert_equal :move, @enemy1.action?(@scenario)
  end
end
