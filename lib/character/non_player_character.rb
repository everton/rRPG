#-*- coding: utf-8 -*-

class NonPlayerCharacter < Character::Base
  def action?(scenario)
    p = player_character(scenario)
    d = distance_of(p.x, p.y)

    if d > √(2) # is not neighbor
      d > reduced_displacement ? :move : :move_and_attack
    else
      :full_attack
    end
  end

  def move(scenario)
    p = player_character(scenario)
    goto(p.x, p.y, full_displacement)
  end

  def full_attack(scenario)
    p = player_character(scenario)
    p.ht -= full_damage if attack_success?
  end

  def move_and_attack(scenario)
    p = player_character(scenario)
    goto(p.x, p.y, reduced_displacement)

    p.ht -= reduced_damage if attack_success?
  end

  private
  def player_character(scenario)
    scenario[:others].each do |char|
      return char if char.is_a? PlayerCharacter
    end
  end
end
