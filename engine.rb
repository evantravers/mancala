class Engine
  @name
  attr_reader :name
  def intialize(name)
    @name = name
  end

  def evaluate(pscore, ppits, oscore, opits)
    move = 1 + rand(6)
    until ppits[move-1] != 0
      move = 1 + rand(6)
    end
    return move
  end
end
