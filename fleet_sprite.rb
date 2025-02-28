class FleetSprite
  attr_reader :id
  attr_accessor :dx, :dy

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
  end

  def move
    @x += @dx
    @y += @dy    
  end
end
