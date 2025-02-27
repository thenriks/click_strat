require 'app/star_system'
require 'app/player'
require 'app/fleet'

class Game
  attr_accessor :players, :systems
  attr_reader :fleets

  def initialize
    @players = [Player.new('tuomas', 0, false), Player.new('AI1', 1, true)]
    @systems = []
    @fleets = []

    @tiles = []
    
    6.times do |y|
      6.times do |x|
        @tiles << { x: x, y: y }
      end
    end

    @tiles = @tiles.shuffle
  end

  def add_fleet(home, dest)
    new_fleet = Fleet.new(1, home, dest, true)
    
    fhome = get_system(home)
    new_fleet.x = fhome.position.x
    new_fleet.y = fhome.position.y

    @fleets << new_fleet
  end

  def move_fleets
    @fleets.each do |fleet|
      d = get_system(fleet.destination).position
      
      if fleet.x < d.x
        fleet.x += 1
      elsif fleet.x > d.x
        fleet.x -= 1
      end

      if fleet.y < d.y
        fleet.y += 1
      elsif fleet.y > d.y
        fleet.y -= 1
      end
    end
  end

  def add_system(sname, owner)
    sys = StarSystem.new(sname, @systems.size + 1, 1, 1, owner)
    tile = @tiles.pop

    sys.set_position(tile.x, tile.y)

    @systems << sys
  end

  def get_system(id)
    @systems.each do |s|
      return s if s.sid == id
    end

    nil
  end

  def get_player(id)
    @players.each do |p|
      return p if p.id == id
    end

    nil
  end

  def end_turn
    @systems.each do |sys|
      sys.end_turn
    end

    @players.each do |plr|
      plr.end_turn
    end
  end

  def handle_turn
    @systems.each do |ssystem|
      r_mod = 0
      owner = get_player(ssystem.owner)
      r_mod += owner.r_level / 10 if owner.r_level > 0

      case ssystem.focus
      when 0
        ssystem.add_power(1 + r_mod)
      when 1
        ssystem.add_sprawl(1 + r_mod)
      when 2
        owner.add_research(1)
      end

      if ssystem.owner != 0
        ssystem.focus = rand(3)
      end
    end

    end_turn
  end
end
