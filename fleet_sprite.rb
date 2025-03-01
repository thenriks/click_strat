class FleetSprite
  attr_reader :id
  attr_accessor :dx, :dy, :active

  attr_sprite

  def initialize(id, x, y)
    @id = id
    @x = x
    @y = y
    @w = 32
    @h = 32
    @dx = 0
    @dy = 0
    @path = 'sprites/ship.png'
    @active = true
    @a = 0
    @fade_in = true
    @fade_out = false
  end

  def tick
    if @fade_in
      if @a < 255
        @a += 5
      else
        @fade_in = false
      end
    elsif @fade_out
      if @a > 0
        @a -= 5
      else
        @fade_out = false
      end
    end
  end

  def move
    @x += @dx
    @y += @dy
  end

  def stop
    @dx = 0
    @dy = 0
  end
end
