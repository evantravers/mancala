class Engine
  @name
  @level
  attr_reader :name
  def initialize(n, level=2)
    @level = level
    @name = n
  end

  def iterate(p1, p2, depth_remaining)
    # for a given position, compute it's value, add to children's positions
    result = 0
    if depth_remaining == 0
      t = Mancala.new(p1.clone, p2.clone)
      result = evaluate(t.p1, t.p2)
    else
      1.upto(6) do | num |
        t = Mancala.new(p1.clone, p2.clone)
        t.move(t.p1, t.p2, num, false)
        result = evaluate(t.p1, t.p2)
        result += iterate(t.p1, t.p2, depth_remaining - 1)
      end
    end
    return result
  end

  def move(p1, p2)
    # random answer
    if @level == 1
      move = 1 + rand(6)
        until p1.pits[move-1] != 0
          move = 1 + rand(6)
        end
    end
    # one level eval function
    if @level == 2
      # TODO treesearch. :)
      # TODO all REFACTORED BECAUSE THIS IS AWFUL
      # pick a random move if you can't find another
      highest = -999
      move = 0
      1.upto(6) do | num |
        t = Mancala.new(p1.clone, p2.clone)
        t.move(t.p1, t.p2, num, false)
        e = evaluate(t.p1, t.p2)
        if e >= highest
          move = num
          highest = e
        end
      end
    end
    if @level == 3
      highest = -999
      move = 0
      depth = 1
      1.upto(6) do | num |
        t = Mancala.new(p1.clone, p2.clone)
        t.move(t.p1, t.p2, num, false)
        e = iterate(t.p1, t.p2, depth)
        if e >= highest
          move = num
          highest = e
        end
      end
    end
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
    instrument("Value of #{p1}'s position: #{value}")

    # time to pick a move
    return value
  end
  
  def to_s
    @name
  end
end
