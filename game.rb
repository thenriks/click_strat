require 'app/star_system'
require 'app/player'
require 'app/fleet'

class Game
  attr_accessor :players, :systems
  attr_reader :fleets

  def initialize
    @players = []

    @systems = []
    @fleets = []

    @tiles = []
    
    6.times do |y|
      8.times do |x|
        @tiles << { x: x, y: y }
      end
    end

    @tiles = @tiles.shuffle

    new_game
  end

  def new_game
    @players = [Player.new('Player', 0, false), Player.new('AI1', 1, true), Player.new('AI2', 2, true)]

    add_system('Prime', 0)
    add_system('Xyz', 1, true)
    add_system('Beta', 0)
    add_system('Asdf', 2, true)
  end

  def add_fleet(owner, home, dest)
    new_fleet = Fleet.new(owner, 50, home, dest, true)

    fhome = get_system(home)
    new_fleet.x = fhome.position.x
    new_fleet.y = fhome.position.y

    @fleets << new_fleet
  end

  def move_fleets
    @fleets = fleets.reject do |fleet|
      fleet.active == false
    end

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

  def add_system(sname, owner, rnd_stats = false)
    if rnd_stats
      sys = StarSystem.new(sname, @systems.size + 1, rand(6), rand(5) + 1, owner)
    else
      sys = StarSystem.new(sname, @systems.size + 1, 1, 1, owner)
    end

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
    notes = []

    @systems.each do |sys|
      note = sys.end_turn
      if note.empty? == false
        note.each do |n|
          notes << n
        end
      end
    end

    @players.each do |plr|
      plr.end_turn
    end

    notes
  end

  # Get list of systems where player with id has claims
  def find_claims(pid)
    claims = []

    @systems.each do |sys|
      if sys.claims.any? { |c| c == pid }
        claims << sys.sid
      end
    end

    claims
  end

  def deploy_fleets
    @players.each do |player|
      claims = find_claims(player.id).shuffle

      if claims.empty? == false
        @systems.each do |sys|
          if sys.strategy == 1 && sys.owner == player.id && sys.power > 1
            sys.power -= 1
            claims = claims.shuffle
            add_fleet(player.id, sys.sid, claims[0])
          end
        end
      end
    end
  end

  # AI players actions
  def ai_actions
    @players.each do |player|
      if player.ai
        @systems.each do |sys|
          if sys.owner != player.id
            if [true, false].sample
              sys.claim(player.id)
            else
              sys.cancel_claim(player.id)
            end            
          end
        end
      end
    end
  end

  def handle_turn
    notes = []

    @fleets.each do |fleet|
      sys = get_system(fleet.destination)
      if fleet.x == sys.position.x && fleet.y == sys.position.y
        roll = rand(100) + 1

        if roll < fleet.power
          if sys.power > 0
            sys.power -= 1
          elsif sys.sprawl > 0
            sys.sprawl -= 1
          end

          notes << { x: sys.position.x, y: sys.position.y, type: :damage, value: -1 }
        else
          fleet.active = false
        end
      end
    end

    @systems.each do |ssystem|
      r_mod = 0
      owner = get_player(ssystem.owner)
      r_mod += owner.r_level / 10 if owner.r_level > 0

      if ssystem.sprawl == 0
        ssystem.focus = 1
      end

      case ssystem.focus
      when 0
        ssystem.add_power(1 + r_mod)
      when 1
        ssystem.add_sprawl(1 + r_mod)
      when 2
        owner.add_research(1)
      end

      if ssystem.owner != 0
        ssystem.focus = get_player(ssystem.owner).preferred_focus
        ssystem.strategy = rand(2)
      end
    end

    end_result = end_turn
    end_result.each do |result|
      notes << result
    end

    ai_actions

    deploy_fleets

    return notes
  end
end
