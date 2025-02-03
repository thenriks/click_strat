class Label
  attr_reader :tag

  def initialize(tag, x, y, text)
    @tag = tag
    @x = x
    @y = y
    @text = text
  end

  def text=(val)
    @text = val
  end

  def primitives
    { 
      x: @x, 
      y: @y, 
      g: 200, 
      vertical_alignment_enum: 0,
      alignment_enum: 0,
      size_px: 32, 
      text: @text 
    }
  end
end
