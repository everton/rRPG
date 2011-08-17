class Fixnum
  def d6
    # i.e: 3.d6 => [6, 6, 6]
    ([6] * self).tap do |dices|
      class << dices
        def +(modifier) # 3.d6 + 2
          @modifier = @modifier.to_i + modifier
          self
        end

        def -(modifier) # 3.d6 - 2
          @modifier = @modifier.to_i - modifier
          self
        end

        def modifier
          @modifier ||= 0
        end

        def ==(other)
          super && @modifier.to_i == other.modifier.to_i
        end

        def inspect
          signal = @modifier.to_i > 0 ? '+' : ''
          "#{self.size}d6#{signal}#{@modifier}"
        end

        def roll
          self.inject(modifier){|s, e| s + rand(e) + 1 }
        end
      end
    end
  end
end
