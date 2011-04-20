#-*- coding: utf-8 -*-

module Regeneration
  def self.init(base, options = {})
    base.after_init do |obj|
      obj.instance_variable_set("@healing_factor",
                                options[:healing_factor] || 1)
    end

    base.before_turn_start :regenerate
  end

  def regenerate
    @ht += @healing_factor
    @ht  =  @max_ht if @ht > @max_ht
  end
end
