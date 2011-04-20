#-*- coding: utf-8 -*-

module Sword
  def self.init(base, options = {})
    base.after_init do |obj|
      obj.instance_variable_set("@sword_modifier",
                                options[:modifier] || 3)
    end
  end

  def full_damage
    (@st + @sword_modifier).roll
  end
end
