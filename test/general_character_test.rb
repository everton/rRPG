#-*- coding: utf-8 -*-

require 'test_helper'

using Dice

class GeneralCharacterTest < GameTestCase
  def setup
    @char = Character::Base.new('Fox Mulder',
                                :x  => 5,  :y  => 5,
                                :ht => 12, :st => 3.d6)
  end

  def test_character_default_initialization
    @john = Character::Base.new 'John'
    assert_equal 'John', @john.name

    assert_equal 10,   @john.ht
    assert_equal 2.d6, @john.st

    # non positioned chars must be randomly positioned by the game
    assert_on_position(@john, nil, nil)
  end

  def test_character_parameterized_initialization
    assert_equal 'Fox Mulder', @char.name

    assert_equal 12,   @char.ht
    assert_equal 3.d6, @char.st

    assert_on_position(@char, 5, 5)
  end

  def test_max_ht_registered
    @char.ht = 5
    assert_equal(12, @char.max_ht)

    @char2 = Character::Base.new('Wolverine', :max_ht => 15)
    assert_equal(15, @char2.max_ht)
  end

  def test_full_displacement
    assert_equal 2 + (12 / 2), @char.full_displacement
  end

  def test_minimum_displacement
    @char.ht = 1
    assert_equal 2, @char.full_displacement
    assert_equal 2, @char.reduced_displacement
  end

  def test_reduced_displacement
    assert_equal 2 + (12 / 4), @char.reduced_displacement
  end

  def test_attack_success?
    # if rand(n) => 3 then d6 becames 4
    mock_rand_with! 3 do
      assert @char.attack_success?

      @char.ht = 12
      assert(@char.attack_success?,
             'Should return success if HT == to dice rolling')

      @char.ht = 13
      assert(@char.attack_success?, 'Should detect fail')
    end
  end

  def test_full_damage
    # if rand(n) => 3 then d6 becames 4
    mock_rand_with! 3 do
      assert_equal 12, @char.full_damage
      @char.st = 3.d6 - 2
      assert_equal 10, @char.full_damage
    end
  end

  def test_minimum_full_damage
    # if rand(n) => 0 then d6 becames 1
    mock_rand_with! 0 do
      assert_equal 3, @char.full_damage
    end
  end

  def test_reduced_damage
    # if rand(n) => 3 then d6 becames 4
    mock_rand_with! 3 do
      assert_equal 12 / 3 + 2, @char.reduced_damage
    end
  end

  def test_minimum_reduced_damage
    # if rand(n) => 0 then d6 becames 1
    mock_rand_with! 0 do
      assert_equal 3 / 3 + 2, @char.reduced_damage
    end
  end

  def test_dead?
    refute @char.dead?

    @char.ht = 0
    assert @char.dead?

    @char.ht = -10
    assert @char.dead?
  end

  def test_distance_of
    √2 = Math.sqrt(2)

    assert_equal  1, @char.distance_of(@char.x + 1, @char.y)
    assert_equal  5, @char.distance_of(@char.x + 3, @char.y + 4)
    assert_equal √2, @char.distance_of(@char.x + 1, @char.y + 1)
  end
end
