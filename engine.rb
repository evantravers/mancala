class Engine
  @name
  attr_reader :name
  def initialize(n)
    @name = n
  end

  def move(p1, p2)
    # TODO treesearch. :)
    # pick a random move if you can't find another
    move = 1 + rand(6)
    until p1.pits[move-1] != 0
      move = 1 + rand(6)
    end
    t = Mancala.clone
    binding.pry
    puts "is the first player 1 same as new player 1? #{p1==t.p1}"
    return move
  end

  def evaluate(p1, p2)
    # TODO refactor these into as few loops as possible
    points = p1.score
    enemy_points = p2.score
    bonusmoves, enemycaptures, captures, bonusmoves, enemybonusmoves = 0, 0, 0, 0, 0
    # - some small # for the ones that you could move past your home
    # look for captures
    p1.pits.each_with_index do | opt, i |
      if p1.pits[i+opt] == 0 and opt != 0
        captures += 1
      end
    end
    # enemy captures
    p2.pits.each_with_index do | opt, i |
      if p2.pits[i+opt] == 0 and opt != 0
        enemycaptures += 1
      end
    end
    # check to see if it can move again
    p1.pits.each_with_index do | opt, i |
      if (p1.pits.size - i == opt and opt != 0)
        bonusmoves += 1
      end
    end
    # check to see if enemy can move again
    p2.pits.each_with_index do | opt, i |
      if (p2.pits.size - i == opt and opt != 0)
        enemybonusmoves += 1
      end
    end
    # we should have all the variables needed for an eval
    # evaluate each possible next move, then return the best move
    value = Integer(3*points - 2.5*enemy_points + 3*bonusmoves - 3*enemybonusmoves + 4*captures - 4*enemycaptures)
    puts "Value of #{p1}'s position: #{value}"

    # time to pick a move
    return value
  end
  
  def to_s
    @name
  end
end
