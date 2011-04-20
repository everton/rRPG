module Directions
  def north
    [@x, @y - 1]
  end

  def northeast
    [@x + 1, @y - 1]
  end

  def east
    [@x + 1, @y]
  end

  def southeast
    [@x + 1, @y + 1]
  end

  def south
    [@x, @y + 1]
  end

  def southwest
    [@x - 1, @y + 1]
  end

  def west
    [@x - 1, @y]
  end

  def northwest
    [@x - 1, @y - 1]
  end
end
