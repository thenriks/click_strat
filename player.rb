class Player
  attr_reader :name, :id, :ai, :owner, :research, :r_level, :r_goal, :ai_srategy

  def initialize(name, id, ai)
    @name = name
    @id = id
    @ai = ai

    @research = 0
    @r_level = 0
    @r_goal = 1

    @ai_strategy = rand(3)
  end

  def preferred_focus
    if rand(3) != 0
      return @ai_strategy
    else
      return rand(3)
    end
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
