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

    $g.players.each_with_index do |player, idx|
      if player.ai
        ai_info = get_widget(:"ai_info#{idx}")
        ai_info.text = "#{player.name} (#{player.r_level})"
      end
    end
  end

  def update
    @widgets = []

    r = Layout.rect(row: 2, col: 16, w: 6, h: 1)
    add_label(:res_info, r.x, r.y, "research: #{$g.players[0].r_level}(#{$g.players[0].research})")

    $g.players.each_with_index do |player, idx|
      if player.ai
        r = Layout.rect(row: 4 + idx, col: 16, w: 6, h: 1)
        add_label(:"ai_info#{idx}", r.x, r.y, "#{player.name} (#{player.r_level})")
      end
    end
  end
end
