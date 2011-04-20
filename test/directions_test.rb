#-*- coding: utf-8 -*-

require 'test_helper'

class Point
  include Directions

  def initialize(x, y)
    @x, @y = x, y
  end
end

class DirectionsTest < GameTestCase
  def setup
    @point = Point.new 3, 3
  end

  def test_north    ; assert_equal([3, 2], @point.north);     end
  def test_northeast; assert_equal([4, 2], @point.northeast); end
  def test_east     ; assert_equal([4, 3], @point.east);      end
  def test_southeast; assert_equal([4, 4], @point.southeast); end
  def test_south    ; assert_equal([3, 4], @point.south);     end
  def test_southwest; assert_equal([2, 4], @point.southwest); end
  def test_west     ; assert_equal([2, 3], @point.west);      end
  def test_northwest; assert_equal([2, 2], @point.northwest); end
end
