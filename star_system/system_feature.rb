require 'app/star_system/feature_component'
require 'app/star_system/component_type'

# Features describe special characteristics of a system.
# One feature can includxe several components that give bonuses or penalties.
class SystemFeature
  def initialize(rnd = false)
    @name = 'GENERIC'
    @components = []

    if rnd
      mult = rand(5) + 1
      val = mult * 0.1
      val *= [-1, 1].sample

      type = rand(5)
      val = rand(5) + 5 if type > 2

      @components << FeatureComponent.new(type, val)
    end
  end

  def add_component(t, v)
    @components << FeatureComponent.new(t, v)
  end

  # calculate total bonus for given type
  def calculate_bonus(type)
    bonus = 0.0

    @components.each do |comp|
      if comp.type == type
        bonus += comp.value
      end
    end

    bonus
  end
end
