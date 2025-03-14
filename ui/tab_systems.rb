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

    r = Layout.rect(row: 2, col: 12, w: 6, h: 1)
    add_label(:sys_caption, r.x, r.y, "systems") 
    r = Layout.rect(row: 3, col: 12, w: 6, h: 1)
    add_label(:sys_owner, r.x, r.y, "Owner: ")
    r = Layout.rect(row: 4, col: 12, w: 6, h: 1)

    focus = 'NIL'
    case $g.get_system(@active_system).focus  
    when 0
      focus = 'Power'
    when 1
      focus = 'Infra'
    when 2
      focus = 'Research'
    end
    add_label(:sys_focus, r.x, r.y, "Focus: #{focus}")

    if $g.get_system(@active_system).owner != 0
      r = Layout.rect(row: 6, col: 12, w: 6, h: 1)
      claim_text = 'Cancel Claim'
      claim_text = 'Claim' if $g.get_system(@active_system).claims.none? { |c| c == 0 }
      add_button(:sys_claim, claim_text, r)
    else
      r = Layout.rect(row: 5, col: 12, w: 2, h: 1)
      add_button(:sys_focus_p, "P", r)
      r = Layout.rect(row: 5, col: 14, w: 2, h: 1)
      add_button(:sys_focus_s, "S", r)
      r = Layout.rect(row: 5, col: 16, w: 2, h: 1)
      add_button(:sys_focus_r, "R", r)
    end
  end

  def tick(game)
    super

    @widgets.each(&:tick)
    sys = game.get_system(@active_system)
    
    sys_info = get_widget(:sys_caption)
    sys_info.text = sys.name

    own_info = get_widget(:sys_owner)
    own_info.text = game.get_player(sys.owner).name
  end
end
