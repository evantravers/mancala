class Engine
  @name
  attr_reader :name
  def initialize(n)
    @name = n
  end

  def evaluate(p1, p2)
    # TODO treesearch. :)
    # Also, evaluation function.
    # What should be in said eval function?
    # - Points in the home
    points = p1.score
    # - Points in opponents home
    enemy_points = p2.score
    # - possible move agains
    bonusmoves = 0
    # - possible captures
    captures = 0
    # - some small # for the ones that you could move past your home
    # pick a random move if you can't find another
    move = 1 + rand(6)
    until p1.pits[move-1] != 0
      move = 1 + rand(6)
    end
    # look for captures
    p1.pits.each_with_index do | opt, i |
      if p1.pits[i+opt] == 0 and opt != 0
        captures += 1
      end
    end
    # check to see if it can move again
    p1.pits.each_with_index do | opt, i |
      if (p1.pits.size - i == opt and opt != 0)
        bonusmoves += 1
      end
    end
    # we should have all the variables needed for an eval
    p1.pits.each do | option |
      # evaluate each possible next move, then return the best move
    end
    return move
  end
  
  def to_s
    @name
  end
end
