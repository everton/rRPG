#-*- coding: utf-8 -*-

require 'test_helper'

class GeneralCharacterTest < GameTestCase
  def setup
    @char = Character.new('Fox Mulder',
                          :x  => 5,  :y  => 5,
                          :ht => 12, :st => 3.d6)
  end

  def test_character_default_initialization
    @unamed = Character.new
    assert_equal @unamed.to_s, @unamed.name

    assert_equal 10,   @unamed.ht
    assert_equal 2.d6, @unamed.st

    assert_on_position(@unamed, 0, 0)
  end

  def test_character_parameterized_initialization
    assert_equal 'Fox Mulder', @char.name

    assert_equal 12,   @char.ht
    assert_equal 3.d6, @char.st

    assert_on_position(@char, 5, 5)
  end

  def test_turn_start!
    def @char.callback1
      @called_callbacks ||= []
      @called_callbacks << '1st'
    end

    def @char.callback2
      @called_callbacks ||= []
      @called_callbacks << '2nd'
    end

    @char.instance_variable_set("@before_turn_start_callbacks",
                                ['callback1', :callback2])

    @char.turn_start!

    assert_equal(@char.instance_variable_get("@called_callbacks"),
                 ['1st', '2nd'])
  end

  def test_full_displacement
    assert_equal 8, @char.full_displacement

    @char.ht = 1
    assert_equal 2, @char.full_displacement
  end

  def test_reduced_displacement
    assert_equal 5, @char.reduced_displacement

    @char.ht = 1
    assert_equal 2, @char.reduced_displacement
  end

  # TODO: test_attack_success?
  # TODO: test_full_damage
  # TODO: test_reduced_damage
  # TODO: test_dead?
  # TODO: test_distance_of(x, y)
end
