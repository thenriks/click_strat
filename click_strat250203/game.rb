require 'app/star_system.rb'
require 'app/player.rb'

class Game
  attr_accessor :players, :systems

  def initialize
    # @players = [{ name: 'tuomas', id: 0, research: 0 , r_level: 0, r_goal: 1 },
    #            { name: 'AI', id: 1, research: 0 , r_level: 0, r_goal: 1 }]
    @players = [Player.new('tuomas', 0), Player.new('AI', 1)]
    # @systems = [StarSystem.new('Prime', 0), StarSystem.new('Beta', 1), StarSystem.new('Xyz', 2, 2, 2, 1)]
    @systems = []

    @tiles = []
    
    6.times do |y|
      6.times do |x|
        @tiles << { x: x, y: y }
      end
    end

    @tiles = @tiles.shuffle
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
        # ssystem.power += 1 + r_mod
        ssystem.add_power(1 + r_mod)
      when 1
        # ssystem.sprawl += 1 + r_mod
        ssystem.add_sprawl(1 + r_mod)
      when 2
        # owner.research += 1
        owner.add_research(1)
      end

      if ssystem.owner != 0
        ssystem.focus = rand(3)
      end
    end

    end_turn
  end
end
