#-*- coding: utf-8 -*-

require 'test_helper'

class IAWhichActionChooseTest < GameTestCase
  def setup
    @enemy = NonPlayerCharacter.new 'CPU01', x: 3, y: 3
  end

  def test_choose_full_attack_when_close_to_player
    neighbors = [[2, 2], [3, 2], [4, 2],
                 [2, 3],         [4, 3],
                 [2, 4], [3, 4], [4, 4]]

    neighbors.each do |x, y|
      assert_action_for_player_at(:full_attack, x, y)
    end
  end

  def test_choose_move_and_attack_case_at_medium_distance
    assert_action_for_player_at(:move_and_attack, 5, 5)
  end

  def test_choose_move_if_far_away
    assert_action_for_player_at(:move, 9, 9)
  end

  private
  def assert_action_for_player_at(action, px, py)
    player = PlayerCharacter.new 'Player', x: px, y: py
    world  = {
      characters: [player, @enemy],
      tl: [0, 0], br: [10, 10]
    }

    assert_equal action, @enemy.action(world)
  end
end
