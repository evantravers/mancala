class Engine
  @name
  attr_reader :name
  def initialize(n)
    @name = n
  end

  def evaluate(pscore, ppits, oscore, opits)
    sleep(1)
    # pick a random move if you can't find another
    move = 1 + rand(6)
    until ppits[move-1] != 0
      move = 1 + rand(6)
    end
    # look for captures
    # TODO make sure this code works.
    ppits.each_with_index do | opt, i |
      if ppits[i+opt] == 0 and opt != 0
        move = i + 1
      end
    end
    # check to see if it can move again
    ppits.each_with_index do | opt, i |
      if (ppits.size - i == opt and opt != 0)
        puts "found a move"
        move = i + 1
      end
    end
    # sleep(1)
    return move
  end
  
  def to_s
    @name
  end
end
