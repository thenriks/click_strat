require 'app/util/color'

class MainMenu
  attr_gtk

  def tick
    @main_menu_counter ||= Kernel.tick_count
    @flip_bool ||= false

    outputs[:scene].transient!
    outputs[:scene].background_color = [0, 0, 0]

    outputs[:scene].labels << { x: 30,
                                y: 450,
                                size_px: 55,
                                **Color::YELLOW,
                                text: "Space Game"
                              }

    if Kernel.tick_count > @main_menu_counter + 60
      @flip_bool = !@flip_bool
      @main_menu_counter = Kernel.tick_count
    end

    if @flip_bool
      outputs[:scene].labels << { x: 30,
                                y: 300,
                                size_px: 40,
                                r: 222,
                                g: 222,
                                b: 222,
                                text: "Click to start!"
                              }
    end

    state.next_scene = :game_main if inputs.keyboard.key_down.enter
    state.next_scene = :game_main if inputs.mouse.click
  end
end

$gtk.reset
