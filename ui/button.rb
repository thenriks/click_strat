class Button
  attr_reader :r, :id
  
  def initialize(id, text, rect)
    @id = id
    @text = text
    @r = rect

    @center = Geometry.rect_center_point(@r)
  end

  def primitives
    [
      {
        x: @r.x,
        y: @r.y,
        w: @r.w,
        h: @r.h,
        path: :pixel
      },
      {
        x: @center.x,
        y: @center.y,
        r: 200,
        alignment_enum: 1,
        vertical_alignment_enum: 1,
        text: @text
      }
    ]
  end
end
