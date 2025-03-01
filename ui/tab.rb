require 'app/ui/label'
require 'app/ui/button'

class Tab
  attr_reader :widgets

  def initialize
    @widgets = []
  end

  def tick(game)
  end

  # Update is used when tab composition is changed
  def update
    
  end

  def get_widget(id)
    @widgets.each do |w|
      return w if w.id == id
    end    
  end

  def add_label(id, x, y, text)
    @widgets << Label.new(id, x, y, text)
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