class Fleet
  attr_reader :id, :power, :home, :destination
  attr_accessor :x, :y

  def initialize(power, home, destination, attack)
    @id = $gtk.create_uuid
    @power = power
    @home = home
    @x = 1
    @y = 1
    @destination = destination
    @attack = attack
  end
end
