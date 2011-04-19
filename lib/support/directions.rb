module Directions
  def north(x = @x, y = @y)
    [x, y - 1]
  end

  def northeast(x = @x, y = @y)
    [x + 1, y + 1]
  end

  def east(x = @x, y = @y)
    [x + 1, y]
  end

  def southeast(x = @x, y = @y)
    [x + 1, y + 1]
  end

  def south(x = @x, y = @y)
    [x, y + 1]
  end

  def southwest(x = @x, y = @y)
    [x - 1, y -1]
  end

  def west(x = @x, y = @y)
    [x - 1, y]
  end

  def northwest(x = @x, y = @y)
    [x - 1, y - 1]
  end
end
