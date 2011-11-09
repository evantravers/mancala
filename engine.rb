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
    if depth_remaining == 1
      t1 = p1.clone
      t2 = p2.clone
      result = evaluate(t1, t2)
    else
      1.upto(6) do | num |
        t1 = p1.clone
        t2 = p2.clone
        t1.move(t2, num, false)
        result = evaluate(t1, t2)
        result += iterate(t1, t2, depth_remaining - 1)
      end
    end
    return result
  end

  def minimax(p1, p2, depth_remaining)
    #if node is a terminal node or depth <= 0:
        #return the heuristic value of node
    #α = -∞
    #for child in node:                       
        #α = max(α, -minimax(child, depth-1))
    #return α
    gameover = true if p1.pits.inject(:+)==0 or p2.pits.inject(:+)==0
    if gameover or depth_remaining <= 0
      return evaluate(p1, p2)
    end
    result = -Float::INFINITY
    1.upto(6) do | num |
      if p1[num] != 0
        t1 = p1.clone
        t2 = p2.clone
        t1.move(t2, num, false)
        result = [result, -minimax(t1, t2, depth_remaining-1)].max
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
      # TODO make sure the indices of the moves is correct
      # pick a random move if you can't find another
      highest = -Float::INFINITY
      move = 0
      1.upto(6) do | num |
        t1 = p1.clone
        t2 = p2.clone
        t1.move(t2,num,false)
        e = evaluate(t1, t2)
        if e >= highest
          move = num
          highest = e
        end
      end
    end
    if @level == 3
      highest = -Float::INFINITY
      move = 0
      depth = 0
      1.upto(6) do | num |
        if p1[num-1] != 0
          e = minimax(p1, p2, depth)
          if e >= highest
            move = num
            highest = e
          end
        end
      end
    end
    instrument("moving #{self}'s pit \##{move}\n", true)
    return move
  end

  def evaluate(p1, p2)
    # TODO refactor these into as few loops as possible
    points = p1.score
    enemy_points = p2.score
    bonusmoves, enemycaptures, captures, enemybonusmoves = 0, 0, 0, 0
    # - some small # for the ones that you could move past your home
    # player ones loop
    p1.pits.each_with_index do | opt, i |
      # look for captures
      if p1.pits[i+opt] == 0 and opt != 0
        captures += 1
      end
      # look for bonus move
      if (p1.pits.size - i == opt and opt != 0)
        bonusmoves += 1
      end
    end

    # player two's loop
    p2.pits.each_with_index do | opt, i |
      if p2.pits[i+opt] == 0 and opt != 0
        enemycaptures += 1
      end
    # check to see if it can move again
      if (p2.pits.size - i == opt and opt != 0)
        enemybonusmoves += 1
      end
    end
    # we should have all the variables needed for an eval
    # evaluate each possible next move, then return the best move
  value = Integer(5*points - 5*enemy_points + 9*bonusmoves - 9*enemybonusmoves + 4*captures - 4*enemycaptures)
    instrument("Value of #{p1}'s position: #{value}")

    # time to pick a move
    return value
  end
  
  def to_s
    @name
  end
end
