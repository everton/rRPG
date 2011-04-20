#-*- coding: utf-8 -*-

module Sword
  def self.init(base, options = {})
  end

  def full_damage
    (@st + 3).roll
  end
end
