require 'app/ui/tab'
require 'app/ui/label'
require 'app/ui/button'

class TabSystems < Tab
  attr_accessor :active_system

  def initialize
    super

    @active_system = 1

    update
  end

  def update
    @widgets = []

    if $g.get_system(@active_system).owner != 0
      r = Layout.rect(row: 2, col: 12, w: 6, h: 1)
      add_label(:sys_caption, r.x, r.y, "systems")
      r = Layout.rect(row: 3, col: 12, w: 6, h: 1)
      add_button(:sys_claim, "Claim", r)
    else
      r = Layout.rect(row: 2, col: 12, w: 6, h: 1)
      add_label(:sys_caption, r.x, r.y, "systems") 
    end
  end

  def tick(game)
    @widgets.each(&:tick)
    sys_info = get_widget(:sys_caption)
    sys_info.text = game.get_system(@active_system).name
  end
end
