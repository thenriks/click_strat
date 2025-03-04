class StarSystem
  attr_accessor :name, :power, :sprawl, :owner, :focus
  attr_reader :sid, :id, :position, :power_pts, :sprawl_pts, :claims

  def initialize(name, id, power = 1, sprawl = 1, owner = 0)
    @name = name
    @sid = id   #TODO: replace sid with id
    @id = id
    @power = power
    @power_pts = 0.0
    @sprawl = sprawl
    @sprawl_pts = 0.0
    @owner = owner
    @focus = 0
    @position = { x: 0, y: 0 }
    @claims = []
  end

  def end_turn
    notes = []

    if check_power == 1
      notes << { x: @position.x, y: @position.y, type: :power, value: 1 }
    end

    if check_sprawl == 1
      notes << { x: @position.x, y: @position.y, type: :sprawl, value: 1 }
    end

    notes
  end

  def check_power
    if @power_pts >= (@power + 1) * 10
      @power_pts -= (@power + 1) * 10
      @power += 1
      return 1
    end

    nil
  end

  def claim(p)
    if @claims.none? { |e| e == p }
      @claims << p
    end

    puts @claims
  end

  def cancel_claim(p)
    @claims = @claims.reject { |c| c == p}

    puts @claims
  end

  def add_power(val)
    @power_pts += val
  end

  def check_sprawl
    if sprawl_pts >= (@sprawl + 1) * 10
      @sprawl_pts -= (@sprawl + 1) * 10
      @sprawl += 1
      return 1
    end

    nil
  end

  def add_sprawl(val)
    @sprawl_pts += val
  end

  def set_position(pos_x, pos_y)
    @position.x = pos_x
    @position.y = pos_y
  end
end
