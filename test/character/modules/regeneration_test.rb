#-*- coding: utf-8 -*-

require_relative '../../test_helper'

class RegenerationTest < GameTestCase
  def setup
    @wolverine = Character::Base.new 'Wolverine', :ht => 10
    @wolverine.have :regeneration

    @wolverine.ht = 5
  end

  def test_regeneration
    @wolverine.turn_start!
    assert_equal 6, @wolverine.ht
  end

  def test_regeneration_should_not_overcome_initial_health
    10.times do
      @wolverine.turn_start!
    end

    assert_equal 10, @wolverine.ht
  end

  def test_more_powerfull_regeneration
    @wolverine.have :regeneration, :healing_factor => 3
    @wolverine.turn_start!

    assert_equal 8, @wolverine.ht
  end

  def test_class_level_regeneration
    @beholder = Beholder.new 'Beh', :ht => 50

    @beholder.ht = 44
    @beholder.turn_start!
    assert_equal 49, @beholder.ht

    @beholder.turn_start!
    assert_equal 50, @beholder.ht
  end

  class Beholder < Character::Base
    have :regeneration, :healing_factor => 5
  end
end

