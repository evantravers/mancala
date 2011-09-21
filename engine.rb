class Engine
  @name
  attr_reader :name
  def initialize(n)
    @name = n
  end

  def evaluate(pscore, ppits, oscore, opits)
    move = 1 + rand(6)
    until ppits[move-1] != 0
      move = 1 + rand(6)
    end
    return move
  end
  
  def to_s
    puts @name
  end
end
