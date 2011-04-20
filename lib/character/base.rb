#-*- coding: utf-8 -*-

module Character
  class Base
    attr_accessor :name, :x, :y, :ht, :max_ht, :st

    include TurnCallback::BeforeStart
    include InitCallback::AfterInit

    include Character::Modules

    def initialize(name, options = {})
      @name   = name
      @x      = options[:x     ] || 0
      @y      = options[:y     ] || 0
      @ht     = options[:ht    ] || 10
      @st     = options[:st    ] || 2.d6
      @max_ht = options[:max_ht] || @ht

      invoke_after_init_callbacks!
    end

    def turn_start!
      before_turn_start_callbacks.each do |callback|
        send callback
      end
    end

    def quit
      # TODO: treat quit action from character perspective
    end

    def goto(x, y, displacement)
      return if x == @x and y == @y

      dist = distance_of(x, y)
      r = displacement / dist

      new_x = @x + ((x - @x) * r).to_i
      new_y = @y + ((y - @y) * r).to_i

      if(distance_of(new_x, new_y) > dist)
        @x, @y = x, y
      else
        @x, @y = new_x, new_y
      end
    end

    def full_displacement
      2 + (@ht / 2)
    end

    def reduced_displacement
      2 + (@ht / 4)
    end

    def attack_success?
      @ht >= 3.d6.roll
    end

    def full_damage
      @st.roll
    end

    def reduced_damage
      2 + full_damage / 3
    end

    def dead?
      @ht < 1
    end

    def distance_of(x, y)
      Δx = Float(x - @x)
      Δy = Float(y - @y)

      √((Δx ** 2) + (Δy ** 2))
    end
  end
end
