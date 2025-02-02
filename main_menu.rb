class MainMenu
  attr_gtk

  def tick
    outputs[:scene].transient!
    outputs[:scene].labels << { x: 30,
                                y: 300,
                                size_px: 40,
                                text: "Press enter to start"
                              }

    state.next_scene = :game_main if inputs.keyboard.key_down.enter
    state.next_scene = :game_main if inputs.mouse.click
  end
end

$gtk.reset
