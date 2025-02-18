require 'app/game'
require 'app/ui/progress_bar'
require 'app/ui/tab'
require 'app/ui/tab_overview'
require 'app/ui/tab_systems'
require 'app/ui/button'

class GameMain
  attr_gtk

  def initialize
    @new_game = true
  end

  def handle_turn
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
  end

  def click_system(id)
    @tab_systems.active_system = id
    if $g.get_system(id).owner == 0
      $g.get_system(id).focus += 1
      $g.get_system(id).focus = 0 if $g.get_system(id).focus > 2
    end
  end

  def toggle_autoplay
    state.autoplay = !state.autoplay
    state.autoplay_counter = 30
  end

  def handle_input
    if inputs.keyboard.key_down.space
      toggle_autoplay
    end

    if inputs.mouse.click
      @ui_el.each do |uitem|
        if inputs.mouse.inside_rect? uitem.r
          puts "click #{uitem.id}"
          case uitem.id
          when :btn_auto
            toggle_autoplay
          when :btn_turn
            handle_turn
          when :btn_overview
            @ui_tab = 1
          when :btn_systems
            @ui_tab = 2
          when :btn_events
            @ui_tab = 3
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

    @new_game = false
    state.slots = []

    $g.systems.each do |sys|
      new_sys = { id: sys.sid, 
                  r: layout.rect(row: (sys.position.y * 2), col: sys.position.x * 2, w: 2, h: 2) }
      new_sys.progress = ProgressBar.new(new_sys.r.x, new_sys.r.y, new_sys.r.w, new_sys.r.h / 16, 10)
      puts sys.sid
      state.slots << new_sys
    end

    @ui_tab = 1
    @tab_overview = TabOverview.new
    r = layout.rect(row: 2, col: 12, w: 6, h: 1)
    @tab_overview.add_label(:res_info, r.x, r.y, "research: #{$g.players[0].r_level}(#{$g.players[0].research})")
    r = layout.rect(row: 3, col: 12, w: 6, h: 1)
    @tab_overview.add_button(:testib, "Testi", r)
    @tab_systems = TabSystems.new
    r = layout.rect(row: 2, col: 12, w: 6, h: 1)
    @tab_systems.add_label(:testi, r.x, r.y, "systems")
    @tab_events = Tab.new
    r = layout.rect(row: 2, col: 12, w: 6, h: 1)
    @tab_events.add_label(:testi, r.x, r.y, "events")
  end

  def tick
    if @new_game
      set_defaults
    end

    state.autoplay ||= false
    state.autoplay_counter ||= 0
    @ui_el ||= [{ id: :btn_turn, r: layout.rect(row: 0, col: 12, w: 5, h: 1) },
                { id: :btn_auto, r: layout.rect(row: 0, col: 17, w: 1, h: 1) },
                { id: :btn_overview, r: layout.rect(row: 1, col: 12, w: 2, h: 1) },
                { id: :btn_systems, r: layout.rect(row: 1, col: 14, w: 2, h: 1) },
                { id: :btn_events, r: layout.rect(row: 1, col: 16, w: 2, h: 1) }]
    
    state.stats_r ||= layout.rect(row: 0, col: 0, w: 4, h: 2)

    outputs[:scene].transient!
    outputs[:scene].background_color = [0,0,0]

    @ui_el.each do |uitem|
      outputs[:scene].sprites << { x: uitem.r.x, y: uitem.r.y, w: uitem.r.w, h: uitem.r.h }
    end

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
                                  g: 200,
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
    

    if state.autoplay
      state.autoplay_counter -= 1

      if state.autoplay_counter < 1
        state.autoplay_counter = 30
        handle_turn
      end
    end

    handle_input
  end
end

# $gtk.reset
