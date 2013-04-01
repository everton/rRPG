#-*- coding: utf-8 -*-

require 'test_helper'

class IABasicActionsTest < GameTestCase
  def setup
    @player =    PlayerCharacter.new 'Player'
    @enemy  = NonPlayerCharacter.new 'CPU01'
    @enemy.x, @enemy.y = 3, 3

    @enemy.fake(:full_damage,     :return => 3)
    @enemy.fake(:reduced_damage,  :return => 2)
    @enemy.fake(:attack_success?, :return => true)

    @scenario = {
      :others => [@player],
      :tl => [0, 0], :br => [10, 10]
    }
  end

  def test_close_move_action
    move_enemy_when_player_in(4, 5) # =~ 2.24u of distance
    assert_on_position(@enemy, 4, 5)
  end

  def test_far_move_action
    move_enemy_when_player_in(9, 9) # =~ 12.73u of distance
    assert_on_position(@enemy, 7, 7)
  end

  def test_full_attack_should_discounting_from_other_ht
    attack_when_player_in(2, 4)
    assert_equal 7, @player.ht
  end

  def test_move_and_attack_should
    move_enemy_when_player_in(4, 5, :move_and_attack) # =~ 2.24u of distance
    assert_on_position(@enemy, 4, 5)

    assert_equal 8, @player.ht, 'Move and attack should '
  end

  def test_should_not_retrieve_others_ht_if_not_successful
    @enemy.fake(:attack_success?, false) do
      attack_when_player_in(2, 4)
      assert_equal 10, @player.ht
    end
  end

  def test_dead
    @player.ht = 0
    assert @player.dead?
    refute  @enemy.dead?
  end

  private
  def attack_when_player_in(px, py, attack = :full_attack)
    @player.x, @player.y = px, py
    @enemy.send(attack, @scenario)
  end

  def move_enemy_when_player_in(px, py, action = :move)
    @player.x, @player.y = px, py
    @enemy.send action, @scenario
  end
end
