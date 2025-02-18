require 'app/ui/tab'
require 'app/ui/label'

class TabOverview < Tab
  def tick(game)
    res_info = get_widget(:res_info)
    res_info.text = "research: #{game.players[0].r_level}(#{game.players[0].research})"
  end
end
