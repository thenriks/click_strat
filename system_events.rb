# UI Events for systems tab

def handle_system_events(uitem, tab)
  case uitem.id
  when :sys_focus_p
    $g.get_system(tab.active_system).focus = 0
  when :sys_focus_s
    $g.get_system(tab.active_system).focus = 1
  when :sys_focus_r
    $g.get_system(tab.active_system).focus = 2
  when :sys_claim
    sys = $g.get_system(tab.active_system)

    if sys.claims.none? { |c| c == 0 }
      sys.claim(0)
    else
      sys.cancel_claim(0)
    end
  end

  tab.update
end
