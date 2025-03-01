require 'app/game'
require 'app/ui/progress_bar'
require 'app/ui/tab'
require 'app/ui/tab_overview'
require 'app/ui/tab_systems'
require 'app/ui/button'
require 'app/util/color'
require 'app/util/states'
require 'app/fleet_sprite'
require 'app/system_events'

class GameMain
  attr_gtk

  def initialize
    $new_game = true
  end

  def update_fleets
    @fleets = @fleets.reject do |fleet|
      fleet.active = false
    end

    $g.fleets.each do |fleet|
      exists = false
      @fleets.each do |spr|
        if spr.id == fleet.id
          # sprite already exists
          dest = layout.rect(row: fleet.y * 2, col: fleet.x * 2, w: 1, h: 1)
          spr.dx = (dest.x - spr.x) / 20
          spr.dy = (dest.y - spr.y) / 20
          exists = true
        end
      end

      if !exists
        r = layout.rect(row: fleet.y * 2, col: fleet.x * 2, w: 1, h: 1)
        @fleets << FleetSprite.new(fleet.id, r.x, r.y)
      end
    end
  end

  def handle_turn
    if @game_state == GameState::WAIT_INPUT
      @game_state = GameState::PREPARE_TURN
      @move_counter = 20
      $g.move_fleets
      update_fleets
    end
  end

  def end_turn
    $g.handle_turn

    state.slots.each do |slot|
      sys = $g.get_system(slot.id)

      if sys.focus == 0
        slot.progress.max = sys.power * 10
        slot.progress.value = sys.power_pts
      elsif sys.focus == 1
        slot.progress.max = sys.sprawl * 10
        slot.progress.value = sys.sprawl_pts
      end
    end

    @game_state = GameState::WAIT_INPUT
  end

  def switch_tab(tab)
    case tab
    when 1
      @tab_el = @tab_overview.widgets
    when 2
      @tab_systems.update
      @tab_el = @tab_systems.widgets
    when 3
      @tab_el = @tab_events.widgets
    end

    @ui_tab = tab
  end

  def click_system(id)
    if id == @tab_systems.active_system && $g.get_system(id).owner == 0
      $g.get_system(id).focus += 1
      $g.get_system(id).focus = 0 if $g.get_system(id).focus > 2
    end
    
    @tab_systems.active_system = id
    switch_tab(2)
  end

  def toggle_autoplay
    state.autoplay = !state.autoplay
    state.autoplay_counter = 30

    # Set :btn_turn inactive when autoplay is on
    btn_turn = @ui_el.find { |uiel| uiel.id == :btn_turn }
    btn_turn.active = !state.autoplay
  end

  def handle_input
    if inputs.keyboard.key_down.space
      toggle_autoplay
    end

    if inputs.mouse.click
      @ui_el.each do |uitem|
        if inputs.mouse.inside_rect? uitem.rect
          puts "click #{uitem.id}"
          uitem.click
          case uitem.id
          when :btn_auto
            toggle_autoplay
          when :btn_turn
            handle_turn if uitem.active
          when :btn_overview
            switch_tab(1)
          when :btn_systems
            switch_tab(2)
          when :btn_events
            switch_tab(3)
          end
        end
      end

      @tab_el.each do |uitem|
        if uitem.clickable
          if inputs.mouse.inside_rect? uitem.rect
            puts "click #{uitem.id}"
            uitem.click

            handle_system_events(uitem, @tab_systems)
          end
        end
      end

      state.slots.each do |slot|
        if inputs.mouse.inside_rect? slot.r
          click_system(slot.id)

          sys = $g.get_system(slot.id)
          if sys.focus == 0
            slot.progress.max = sys.power * 10
            slot.progress.value = sys.power_pts
          elsif sys.focus == 1
            slot.progress.max = sys.sprawl * 10
            slot.progress.value = sys.sprawl_pts
          end
        end
      end
    end
  end

  def focus_char(foc)
    if foc == 0
      'P'
    elsif foc == 1
      'S'
    else
      'R'
    end
  end

  def set_defaults
    puts 'new_game'
    $g = Game.new

    $g.add_system('Prime', 0)
    $g.add_system('Xyz', 1)
    $g.add_system('Beta', 0)

    $new_game = false
    state.slots = []

    $g.systems.each do |sys|
      new_sys = { id: sys.sid, 
                  r: layout.rect(row: (sys.position.y * 2), col: sys.position.x * 2, w: 2, h: 2) }
      new_sys.progress = ProgressBar.new(new_sys.r.x, new_sys.r.y, new_sys.r.w, new_sys.r.h / 16, 10)
      puts sys.sid
      state.slots << new_sys
    end

    $g.add_fleet(1, 2)
    # fl = FleetSprite.new(123)
    # fl.dx = 1
    # fl.dy = 1
    @fleets = []

    @ui_tab = 1
    @tab_overview = TabOverview.new
    @tab_systems = TabSystems.new
    @tab_events = Tab.new
    r = layout.rect(row: 2, col: 12, w: 6, h: 1)
    @tab_events.add_label(:testi, r.x, r.y, "events")
    @tab_el = @tab_overview.widgets    

    @game_state = GameState::WAIT_INPUT
    @move_counter = 0

    update_fleets
  end

  def tick
    if $new_game
      set_defaults
    end

    state.autoplay ||= false
    state.autoplay_counter ||= 0

    @ui_el ||= [Button.new(:btn_turn, 'Turn', layout.rect(row: 0, col: 12, w: 5, h: 1)),
                Button.new(:btn_auto, '>', layout.rect(row: 0, col: 17, w: 1, h: 1)),
                Button.new(:btn_overview, 'ovr', layout.rect(row: 1, col: 12, w: 2, h: 1)),
                Button.new(:btn_systems, 'sys', layout.rect(row: 1, col: 14, w: 2, h: 1)),
                Button.new(:btn_events, 'eve', layout.rect(row: 1, col: 16, w: 2, h: 1))]
    state.stats_r ||= layout.rect(row: 0, col: 0, w: 4, h: 2)

    outputs[:scene].transient!
    outputs[:scene].background_color = [0,0,0]

    # Gameboard
    state.slots.each do |slot|
      sys = $g.get_system(slot.id)

      if sys.owner == 0
        outputs[:scene].sprites << 
          { x: slot.r.x, y: slot.r.y, w: slot.r.w, h: slot.r.h, r: 100, g: 100, b: 100, path: :pixel }
        outputs[:scene].sprites << slot.progress if sys.focus != 2
      end
      outputs[:scene].sprites << 
        { x: slot.r.x, y: slot.r.y, w: slot.r.w, h: slot.r.h, path: 'sprites/misc/star.png' }

      outputs[:scene].labels << { x: slot.r.x, y: slot.r.y + slot.r.h,
                                  vertical_alignment_enum: 2,
                                  alignment_enum: 0,
                                  size_px: 32,
                                  **Color.green_text,
                                  text: sys.name }

      outputs[:scene].labels << { x: slot.r.x + slot.r.w, y: slot.r.y + slot.r.h,
                                  vertical_alignment_enum: 2,
                                  alignment_enum: 2,
                                  size_px: 32,
                                  g: 200,
                                  text: focus_char(sys.focus) }

      outputs[:scene].labels << { x: slot.r.x, y: slot.r.y,
                                  vertical_alignment_enum: 0,
                                  alignment_enum: 0,
                                  size_px: 40,
                                  g: 200,
                                  text: "#{sys.power.round}/#{sys.sprawl.round}" }
    end
    
    @fleets.each(&:tick)
    @fleets.each do |fleet|
      outputs[:scene].sprites << fleet
    end

    # UI
    @ui_el.each do |uitem|
      uitem.tick
      outputs[:scene].primitives << uitem.primitives
    end

    case @ui_tab
    when 1
      @tab_overview.tick($g)
      outputs[:scene].primitives << @tab_overview.primitives
    when 2
      @tab_systems.tick($g)
      outputs[:scene].primitives << @tab_systems.primitives
    when 3
      outputs[:scene].primitives << @tab_events.primitives
    end

    $args.outputs.debug << "mcounter: #{@move_counter}"

    if @game_state == GameState::WAIT_INPUT
      if state.autoplay
        state.autoplay_counter -= 1

        if state.autoplay_counter < 1
          state.autoplay_counter = 30
          handle_turn
        end
      end
    elsif @game_state == GameState::PREPARE_TURN
      @move_counter -= 1

      if @move_counter < 1
        @fleets.each(&:stop)
        @game_state = GameState::END_TURN
      end

      @fleets.each(&:move)
    elsif @game_state == GameState::END_TURN
      end_turn
    end

    handle_input
  end
end

def reset args
  $new_game = true
  $game = nil
end

# $gtk.reset
