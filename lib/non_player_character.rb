#-*- coding: utf-8 -*-

class NonPlayerCharacter < Character
  def action?(scenario)
    p = player_character(scenario)
    d = distance_of(p.x, p.y)

    u = √ 2
    if d > u
      d > 2 * u ? :move : :move_and_attack
    else
      :full_attack
    end
  end

  private
  def distance_of(xo, yo)
    Δx = xo - self.x
    Δy = yo - self.y

    √((Δx ** 2) + (Δy ** 2))
  end

  def player_character(scenario)
    scenario[:others].each do |char|
      return char if char.is_a? PlayerCharacter
    end
  end
end
