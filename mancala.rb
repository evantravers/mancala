require 'pp'
require 'pry'

class Player
  @number
  @score
  @human
  @engine
  @pits
  attr_reader :number
  attr_accessor :score, :pits
  def initialize(player, is_human=true)
    @human = is_human
    @score = 0
    @number = player
    @pits = Array.new(6).map{|slot| slot = 3}
  end
  def [] n
    @pits[n]
  end
  def []= n, a
    @pits[n] = a
  end
end

class Mancala
  # TODO change this based on the botc
  @p1
  @p2
  @gameover

  def initialize
    # create the arrays and fill them in w/ proper # of pieces.
    @gameover = false
    @p1 = Player.new(1)
    @p2 = Player.new(2)
  end

  def move(player, opponent, pit)
    # going to be a value between 1 and numpieces
    puts "moving player #{player.number}'s pit \##{pit}"
    pit=pit.to_i
    # TODO I hate this player selection. Make this DRY please kthxbai
    remaining = player[pit-1]
    range = remaining
    player.pits[pit-1]=0
    player.pits[pit, remaining]=player.pits[pit, remaining].map!{|t| t += 1}
    # subtract the items you have dropped
    remaining = remaining - player[pit..-1].size
    if remaining > 0
      # then this goes around the board
      # put one in your home
      remaining -= 1
      player.score += 1
      if remaining > 0
        opponent.pits[0, remaining]=player.pits[0, remaining].map!{|t| t += 1}
      else
        unless player.pits.inject(:+) == 0
          puts self
          puts "you get another turn!"
          input = gets.chomp!.to_i
          until [1, 2, 3, 4, 5, 6].include?(input)
            puts "please enter an integer from 1-6"
            input = gets.chomp!.to_i
          end
          move(player, opponent, input)
        end
      end
    else
      # ending on this side of the board... gotta check empty
      # going to be a 1 if capture, because you've already put down the rest of the pieces
      if player[pit+range-1] == 1
        puts "empty! you capture!"
        player.score += opponent[-1 * (pit+range)]
        opponent.pits[-1 * (pit+range)] = 0
      end
    end
  end

  def game
    # this should be the game loop
    # you should check for moves, then check to see if game has ended
    player    = @p1
    opponent  = @p2

    until @gameover
      # prompt player
      puts self
      puts "Player #{player.number}, enter your move!"
      input = gets.chomp!.to_i
      until [1, 2, 3, 4, 5, 6].include?(input)
        puts "please enter an integer from 1-6"
        input = gets.chomp!.to_i
      end
      move(player, opponent, input)
      @gameover = true if player.pits.inject(:+)==0 or opponent.pits.inject(:+)==0
      # switch positions
      player, opponent = opponent, player
    end
    # TODO refactor this
    if @p1.score > @p2.score
      puts "Player one wins with #{@p1.get_score} to #{@p2.get_score}!"
    else
      puts "Player two wins with #{@p2.get_score} to #{@p1.get_score}!"
    end
  end

  def to_s
    p1s = @p1.pits
    p2s = @p2.pits
    p1h_b = @p1.score.to_s
    p2h_b = @p2.score.to_s

    if p1h_b.size == 1 
      p1h_b = " " + p1h_b
    end
    if p2h_b.size == 1 
      p2h_b = " " + p2h_b
    end
    "        6 5 4 3 2 1  \n    +-----------------+\n    |  #{p2s[6]} #{p2s[5]} #{p2s[4]} #{p2s[3]} #{p2s[2]} #{p2s[1]} #{p2s[0]}   |\n  P2|#{p2h_b}            #{p1h_b} |P1\n    |   #{p1s[0]} #{p1s[1]} #{p1s[2]} #{p1s[3]} #{p1s[4]} #{p1s[5]} #{p1s[6]}  |\n    +-----------------+\n        1 2 3 4 5 6"
  end
end

b = Mancala.new
b.game
