require 'app/ui/widget'

class Label < Widget
  attr_reader :id

  def initialize(id, x, y, text)
    @id = id
    @x = x
    @y = y
    @text = text
    @a = 255
  end

  def tick
    
  end

  def text=(val)
    @text = val
  end

  def primitives
    { 
      x: @x,
      y: @y,
      g: 200,
      a: @a,
      vertical_alignment_enum: 0,
      alignment_enum: 0,
      size_px: 32,
      text: @text
    }
  end
end
