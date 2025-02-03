require 'app/ui/label'
require 'app/ui/button'

class Tab
  def initialize
    @widgets = []
  end

  def get_widget(tag)
    @widgets.each do |w|
      return w if w.tag == tag
    end    
  end

  def add_label(tag, x, y, text)
    @widgets << Label.new(tag, x, y, text)
  end

  def add_button(id, text, rect)
    @widgets << Button.new(id, text, rect)
  end

  def primitives
    ret = []
    
    @widgets.each do |w|
      ret << w.primitives
    end

    ret
  end
end