#-*- coding: utf-8 -*-

require 'test_helper'

class CharacterMovimentsTest < GameTestCase
  include Directions

  def setup
    # Scully never was where she is supposed to be!
    @x, @y = 5, 5
    @char  = Character::Base.new('Dana Scully',
                                 :x  => @x,  :y  => @y)
  end

  def test_void_moviment
    should_go_to [@x, @y]
  end

  def test_goto_north
    should_go_to north
  end

  def test_goto_northeast
    should_go_to northeast
  end

  def test_goto_east
    should_go_to east
  end

  def test_goto_southeast
    should_go_to southeast
  end

  def test_goto_south
    should_go_to south
  end

  def test_goto_southwest
    should_go_to southwest
  end

  def test_goto_west
    should_go_to west
  end

  def test_goto_northwest
    should_go_to northwest
  end

  def test_goto_destination_closest_than_displacement
    should_go_to northwest, 5
  end

  def test_try_going_to_destination_further_than_displacement
    @char.goto(1, 2, 3) # needs 5 in displacement
    assert_on_position(@char, 3, 4)
  end

  private
  def should_go_to(xy, d = 2)
    x, y = *xy
    @char.goto(x, y, d)
    assert_on_position(@char, x, y)
  end
end
