class ProgressBar
  attr_sprite

  def initialize(x, y, width, height, max)
    @value = 0
    @max = max

    @max_w = width

    @x = x
    @y = y
    @w = 0
    @h = height
    @path = :pixel
  end

  def value=(val)
    @value = val

    @w = (@max_w / @max) * @value
  end

  def max=(val)
    @max = val
  end

  def add(val)
    @value += val

    @w = (@max_w / @max) * @value
  end
end
