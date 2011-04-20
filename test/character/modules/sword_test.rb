require_relative '../../test_helper'

class SwordTest < GameTestCase
  def setup
    @warrior = Character::Base.new 'Warrior', :ht => 10, :st => 3.d6
    @warrior.have :sword

    @basic_sword_modifier = +3
  end

  def test_sword_add_modifier
    # if rand(n) => 3 then d6 becames 4
    mock_rand_with! 3 do
      assert_equal(3.d6, @warrior.st)
      assert_equal((3.d6 + @basic_sword_modifier).roll,
                   @warrior.full_damage)

      # @warrior.st = 2.d6
      # expected = (2.d6 + @basic_sword_modifier).roll
      # assert_equal expected, @warrior.full_damage
    end
  end
end
