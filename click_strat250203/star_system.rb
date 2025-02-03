class StarSystem
  attr_accessor :name, :power, :sprawl, :owner, :focus
  attr_reader :sid, :position, :power_pts, :sprawl_pts

  def initialize(name, id, power = 1, sprawl = 1, owner = 0)
    @name = name
    @sid = id
    @power = power
    @power_pts = 0.0
    @sprawl = sprawl
    @sprawl_pts = 0.0
    @owner = owner
    @focus = 0
    @position = { x: 0, y: 0 }
  end

  def end_turn
    check_power
    check_sprawl
  end

  def check_power
    if @power_pts >= @power * 10
      @power_pts -= @power * 10
      @power += 1
    end
  end

  def add_power(val)
    @power_pts += val
  end

  def check_sprawl
    if sprawl_pts >= @sprawl * 10
      @sprawl_pts -= @sprawl * 10
      @sprawl += 1
    end
  end

  def add_sprawl(val)
    @sprawl_pts += val
  end

  def set_position(pos_x, pos_y)
    @position.x = pos_x
    @position.y = pos_y
  end
end
