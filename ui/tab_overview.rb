require 'app/ui/tab'
require 'app/ui/label'
require 'app/ui/button'

class TabOverview < Tab
  def initialize
    super

    update
  end

  def tick(game)
    super

    @widgets.each(&:tick)
    res_info = get_widget(:res_info)
    res_info.text = "research: #{game.players[0].r_level}(#{game.players[0].research})"
  end

  def update
    @widgets = []

    r = Layout.rect(row: 2, col: 12, w: 6, h: 1)
    add_label(:res_info, r.x, r.y, "research: #{$g.players[0].r_level}(#{$g.players[0].research})")
    r = Layout.rect(row: 3, col: 12, w: 6, h: 1)
    add_button(:testib, "Testi", r)
  end
end
