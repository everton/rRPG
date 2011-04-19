#-*- coding: utf-8 -*-

require 'test_helper'

class BeforeTurnStartCallbacksTest < GameTestCase
  def test_without_callbacks_registered
    char = CharacterWithoutCallbacks.new
    char.turn_start!

    refute char.callback_calls
  end

  def test_turn_start_should_calls_callback
    char = CharacterWithCallbacks.new
    char.turn_start!

    assert_equal 2, char.callback_calls
  end

  def test_callbacks_should_be_called_once
    char = CharacterWithRepeatedCallbacks.new
    char.turn_start!

    assert_equal 2, char.callback_calls
  end

  def test_instances_callbacks
    magneto   = CharacterWithCallbacks.new
    wolverine = CharacterWithCallbacks.new

    def wolverine.regenerate
      @callback_calls ||= 0
      @callback_calls  += 1

      @regenerated = true  # do something with health!
    end

    magneto.turn_start!

    wolverine.before_turn_start :regenerate
    wolverine.turn_start!

    assert_equal 2,   magneto.callback_calls
    assert_equal 3, wolverine.callback_calls

    assert(wolverine.instance_variable_get("@regenerated"),
           'ObjectCallback not called on before_turn_start')
  end

  private
  class CharacterWithoutCallbacks < Character
    attr_accessor :callback_calls
  end

  class CharacterWithCallbacks < CharacterWithoutCallbacks
    before_turn_start :my_1st_custom_callback
    before_turn_start :my_2nd_custom_callback

    def my_1st_custom_callback
      @callback_calls ||= 0
      @callback_calls  += 1
    end

    def my_2nd_custom_callback
      @callback_calls ||= 0
      @callback_calls  += 1
    end
  end

  class CharacterWithRepeatedCallbacks < CharacterWithCallbacks
    before_turn_start :my_1st_custom_callback
  end
end
