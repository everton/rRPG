#-*- coding: utf-8 -*-

require 'test_helper'

class InitCallbacksTest < GameTestCase
  def test_without_callbacks_registered
    char = CharacterWithoutInitCallbacks.new 'WithoutInit'
    refute char.callback_calls
  end

  def test_with_init_callback
    char = CharacterWithInitCallbacks.new 'WithInit'
    assert_equal 2, char.callback_calls
  end

  def test_callbacks_should_be_called_once
    char = CharacterWithRepeatedInitCallbacks.new 'WithoutRepeatedInit'
    assert_equal 2, char.callback_calls
  end

  def test_instances_callbacks
    commoner = CharacterWithInitCallbacks.new 'WithInit1'
    warrior  = CharacterWithInitCallbacks.new 'WithInit2'

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
