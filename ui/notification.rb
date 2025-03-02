class Notification
  attr_reader :active

  def initialize(rect, color, value)
    @color = color
    @value = value
    @a = 175
    @life = 50
    @active = true

    @rect = rect

    @center = Geometry.rect_center_point(@rect)
  end

  def tick
    @life -= 1
    @a -= 3
    @rect.y += 1
    @center = Geometry.rect_center_point(@rect)

    if @life < 1
      @active = false
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
        **@color,
        path: :pixel
      },
      {
        x: @center.x,
        y: @center.y,
        r: 220,
        g: 220,
        b: 220,
        a: @a,
        size_enum: 14,
        alignment_enum: 1,
        vertical_alignment_enum: 1,
        text: @value
      }
    ]
  end
end
