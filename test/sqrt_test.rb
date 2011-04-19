#-*- coding: utf-8 -*-

require 'test_helper'

class SqrtTest < GameTestCase
  def test_alias_√
    assert_equal 3, √(9)
  end
end
