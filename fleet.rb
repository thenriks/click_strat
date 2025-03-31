class Fleet
  attr_reader :owner, :id, :home, :destination
  attr_accessor :x, :y, :active, :power

  def initialize(owner, power, home, destination, attack)
    @owner = owner
    @id = $gtk.create_uuid
    @power = power
    @home = home
    @x = 1
    @y = 1
    @destination = destination
    @attack = attack
    @active = true
  end
end
