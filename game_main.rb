require 'app/game.rb'
require 'app/ui/progress_bar.rb'

class GameMain
  attr_gtk

  def initialize
    # $g = Game.new
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
    if $g.get_system(id).owner == 0
      $g.get_system(id).focus += 1
      $g.get_system(id).focus = 0 if $g.get_system(id).focus > 2
    end
  end

  def handle_input
    if inputs.keyboard.key_down.space
      state.autoplay = !state.autoplay
      state.autoplay_counter = 30
    end

    if inputs.mouse.click
      @ui_el.each do |uitem|
        if inputs.mouse.inside_rect? uitem.r
          # puts "click #{uitem.id}"
          case uitem.id
          when :btn_turn
            handle_turn
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
  end

  def tick
    if @new_game
      set_defaults
    end

    state.autoplay ||= false
    state.autoplay_counter ||= 0
    @ui_el ||= [{ id: :btn_turn, r: layout.rect(row: 0, col: 12, w: 4, h: 1) },
             { id: :btn_auto, r: layout.rect(row: 0, col: 16, w: 1, h: 1) },]
    state.stats_r ||= layout.rect(row: 0, col: 0, w: 4, h: 2)

    outputs[:scene].transient!
    outputs[:scene].background_color = [0,0,0]
    # outputs[:scene].sprites << { x: state.r.x, y: state.r.y, w: state.r.w, h: state.r.h }
    @ui_el.each do |uitem|
      outputs[:scene].sprites << { x: uitem.r.x, y: uitem.r.y, w: uitem.r.w, h: uitem.r.h }
    end

    state.slots.each do |slot|
      sys = $g.get_system(slot.id)

      if sys.owner == 0
        outputs[:scene].sprites << 
          { x: slot.r.x, y: slot.r.y, w: slot.r.w, h: slot.r.h, r: 100, g: 100, b: 100, path: :pixel }
        outputs[:scene].sprites << slot.progress
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

    outputs[:scene].labels << { x: state.stats_r.x,
                                y: state.stats_r.y,
                                vertical_alignment_enum: 0,
                                alignment_enum: 0,
                                size_px: 40,
                                g: 200,
                                text: "research: #{$g.players[0].r_level}(#{$g.players[0].research})" }

    outputs[:scene].labels << { x: 100,
                                y: 100,
                                vertical_alignment_enum: 2,
                                alignment_enum: 0,
                                size_px: 32,
                                g: 200,
                                text: state.autoplay }

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
