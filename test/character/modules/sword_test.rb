require_relative '../../test_helper'

class SwordTest < GameTestCase
  def setup
    @warrior = Character::Base.new 'Warrior', :ht => 10, :st => 3.d6
    @warrior.have :sword

    @basic_sword_modifier = +3
  end

  def test_sword_add_modifier
    assert_correct_st_and_damage(@warrior, 3.d6,
                                 @basic_sword_modifier)

    @warrior.st = 2.d6
    assert_correct_st_and_damage(@warrior, 2.d6,
                                 @basic_sword_modifier)
  end

  def test_sword_with_special_default_modifier
    @warrior.have :sword, :modifier => 5
    assert_correct_st_and_damage(@warrior, 3.d6, 5)
  end

  def test_class_level_regeneration
    default_sword_modifier = 2
    assert_correct_st_and_damage(Warrior.new('Conan', st: 4.d6),
                                 4.d6, default_sword_modifier)
  end

  private
  def assert_correct_st_and_damage(char, expected_st,
                                   expected_modifier)

    mock_rand_with! 3 do
      assert_equal(expected_st, char.st)
      expected_full_damage = (expected_st + expected_modifier).roll
      assert_equal(expected_full_damage, char.full_damage)
    end
  end

  class Warrior < Character::Base
    have :sword, :modifier => 2
  end
end
