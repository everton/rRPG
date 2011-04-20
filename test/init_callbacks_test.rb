#-*- coding: utf-8 -*-

require 'test_helper'

class InitCallbacksTest < GameTestCase
  def test_without_callbacks_registered
    char = CharacterWithoutInitCallbacks.new
    refute char.callback_calls
  end

  def test_with_init_callback
    char = CharacterWithInitCallbacks.new
    assert_equal 2, char.callback_calls
  end

  def test_callbacks_should_be_called_once
    char = CharacterWithRepeatedInitCallbacks.new
    assert_equal 2, char.callback_calls
  end

  def test_instances_callbacks
    commoner = CharacterWithInitCallbacks.new
    warrior  = CharacterWithInitCallbacks.new

    def warrior.take_a_sword
      @callback_calls ||= 0
      @callback_calls  += 1

      @sword_taked = true  # do something with st!
    end

    warrior.after_init :take_a_sword # should be called Immediately

    assert_equal 2, commoner.callback_calls
    assert_equal 3,  warrior.callback_calls

    assert(warrior.instance_variable_get("@sword_taked"),
           'ObjectCallback not called on after_init')
  end

  # def test_turn_start_order
  #   char = CharacterWithoutCallbacks.new

  #   def char.callback1
  #     @called_callbacks ||= []
  #     @called_callbacks << '1st'
  #   end

  #   def char.callback2
  #     @called_callbacks ||= []
  #     @called_callbacks << '2nd'
  #   end

  #   char.instance_variable_set("@before_turn_start_callbacks",
  #                              ['callback1', :callback2])

  #   char.turn_start!

  #   assert_equal(char.instance_variable_get("@called_callbacks"),
  #                ['1st', '2nd'])
  # end

  private
  class CharacterWithoutInitCallbacks < Character::Base
    attr_accessor :callback_calls
  end

  class CharacterWithInitCallbacks < CharacterWithoutInitCallbacks
    after_init :my_1st_custom_callback
    after_init :my_2nd_custom_callback

    def my_1st_custom_callback
      @callback_calls ||= 0
      @callback_calls  += 1
    end

    def my_2nd_custom_callback
      @callback_calls ||= 0
      @callback_calls  += 1
    end
  end

  class CharacterWithRepeatedInitCallbacks < CharacterWithInitCallbacks
    after_init :my_1st_custom_callback
  end
end
