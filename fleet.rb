class Fleet
  attr_reader :power, :home, :destination
  attr_accessor :x, :y

  def initialize(power, home, destination, attack)
    @power = power
    @home = home
    @x = 1
    @y = 1
    @destination = destination
    @attack = attack
  end
end
