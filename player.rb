class Player
  attr_reader :name, :id, :ai, :research, :r_level, :r_goal

  def initialize(name, id, ai)
    @name = name
    @id = id
    @ai = ai

    @research = 0
    @r_level = 0
    @r_goal = 1
  end

  def end_turn
    if @research >= r_goal
      @r_level += 1
      @r_goal *= 2
    end
  end

  def add_research(val)
    @research += val
  end
end
