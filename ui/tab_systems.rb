require 'app/ui/tab'
require 'app/ui/label'

class TabSystems < Tab
  attr_accessor :active_system

  def initialize
    super.initialize

    @active_system = 1
  end

  def tick(game)
    sys_info = get_widget(:testi)
    sys_info.text = game.get_system(@active_system).name
  end
end
