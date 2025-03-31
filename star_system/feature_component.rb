# Components grant bonus or penalty for certain stats.
class FeatureComponent
  attr_accessor :type, :value

  def initialize(t, v)
    @type = t
    @value = v
  end
end
