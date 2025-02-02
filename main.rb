require 'app/main_menu'
require 'app/game_main'

class RootScene
  attr_gtk

  def initialize
    @main_menu = MainMenu.new
    @game_main = GameMain.new
  end

  def tick
    defaults
    render
    tick_scene
  end

  def defaults
    set_current_scene! :main_menu if state.tick_count == 0
    state.scene_transition_duration ||= 30
  end

  def render
    a = if state.transition_scene_at
          255 * state.transition_scene_at.ease(state.scene_transition_duration, :flip)
        elsif state.current_scene_at
          255 * state.current_scene_at.ease(state.scene_transition_duration)
        else
          255
        end

    outputs.sprites << { x: 0, y: 0, w: 1280, h: 720, path: :scene, a: a }
  end

  def tick_scene
    current_scene = state.current_scene

    @current_scene.args = args
    @current_scene.tick

    if current_scene != state.current_scene
      raise "state.current_scene changed mid tick from #{current_scene} to #{state.current_scene}. To change scenes, set state.next_scene."
    end

    if state.next_scene && state.next_scene != state.transition_scene && state.next_scene != state.current_scene
      state.transition_scene_at = state.tick_count
      state.transition_scene = state.next_scene
    end

    if state.transition_scene_at && state.transition_scene_at.elapsed_time >= state.scene_transition_duration
      set_current_scene! state.transition_scene
    end

    state.next_scene = nil
  end

  def set_current_scene! id
    return if state.current_scene == id
    state.current_scene = id
    state.current_scene_at = state.tick_count
    state.transition_scene = nil
    state.transition_scene_at = nil

    if state.current_scene == :main_menu
      @current_scene = @main_menu
    elsif state.current_scene == :game_main
      @current_scene = @game_main
    end
  end
end

def tick args
  $game ||= RootScene.new
  $game.args = args
  $game.tick
end
