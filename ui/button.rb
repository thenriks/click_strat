require 'app/ui/widget'

class Button < Widget
  attr_reader :rect, :id, :active
  
  def initialize(id, text, rect)
    @id = id
    @text = text
    @rect = rect
    @clickable = true
    @active = true
    @a = 255
    @r = 255
    @g = 255
    @b = 255

    @center = Geometry.rect_center_point(@rect)
  end

  def click
    if @active
      @a = 155
    end  
  end

  def tick
    if @a < 255
      @a += 5
    end
  end

  def active=(val)
    @active = val

    if @active
      @r = 255
      @g = 255
      @b = 255
    else
      @r = 120
      @g = 120
      @b = 120
    end
  end

  def primitives
    [
      {
        x: @rect.x,
        y: @rect.y,
        w: @rect.w,
        h: @rect.h,
        a: @a,
        r: @r,
        g: @g,
        b: @b,
        path: :pixel
      },
      {
        x: @center.x,
        y: @center.y,
        r: 0,
        g: 0,
        b: 0,
        a: @a,
        alignment_enum: 1,
        vertical_alignment_enum: 1,
        text: @text
      }
    ]
  end
end
