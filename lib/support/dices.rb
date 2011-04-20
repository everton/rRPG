class Fixnum
  def d6
    dices = [6] * self # i.e: 3.d6 => [6, 6, 6]

    def dices.+(modifier) # 3.d6 + 2
      @modifier = @modifier.to_i + modifier
      self
    end

    def dices.-(modifier) # 3.d6 - 2
      @modifier = @modifier.to_i - modifier
      self
    end

    def dices.modifier
      @modifier
    end

    def dices.==(other)
      self && @modifier == other.modifier
    end

    def dices.inspect
      signal = @modifier.to_i < 0 ? '' : '+'
      "#{self.size}d6#{signal}#{@modifier}"
    end

    def dices.roll
      self.inject(@modifier || 0){|s, e| s + rand(e) + 1 }
    end

    dices
  end
end
