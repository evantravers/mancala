require 'pp'
require 'pry'
require './engine.rb'

Names_of_bots = ['Master Control Program', 'Tron', 'Hal 9000', 'Marvin the Paranoid Android', 'SHODAN', 'EDI', 'Cortana', '343 Guilty Spark', 'The Intersect', 'S.A.R.A.H.', 'LCARS', 'GLADoS', 'Skynet', 'BASS', 'Jarvis', 'The Chessmaster 3000', 'Mavis Beacon']

def instrument(string, display=false)
  if display
    puts string
  end
end

class Player
  @number
  @score
  @human
  @engine
  @pits
  attr_reader :number, :human, :engine
  attr_accessor :score, :pits

  def initialize(player, engine)
    if engine == 0
      @human = true
    else
      @human = false
      @engine = Engine.new(Names_of_bots[rand(Names_of_bots.size)], engine)
    end
    @score = 0
    @number = player
    @pits = Array.new(6).map{|slot| slot = 3}
  end

  def pick_pit(opponent)
    if self.human
      instrument(self, self.human)
      puts "#{self}, enter your move!"
      move = gets.chomp!
      if move == "exit"
        puts "bye!"
        exit
      end
      move = move.to_i
      until 1.upto(6).include?(move)
        puts "Please enter an integer from 1-6:"
        move = gets.chomp!.to_i
      end
      until self[move-1] != 0
        puts "Don't pick an empty space! Pick again:"
        move = gets.chomp!.to_i
      end
    else
      # bot!
      instrument(self, self.human)
      # TODO abstract this out of here into the engine
      puts "#{self} is thinking... "
      move = self.engine_eval(opponent)
    end
    return move
    
  end

  # accepts a value between 1 and 6
  def move(opponent, pit, display=false)
    if self.human
      display = true
    end
    instrument("moving #{self}'s pit \##{pit}\n", display)
    pit=pit.to_i
    remaining = self[pit-1]
    range = remaining
    self.pits[pit-1]=0
    self.pits[pit, remaining]=self.pits[pit, remaining].map!{|t| t += 1}
    # subtract the items you have dropped
    remaining = remaining - self[pit..-1].size
    if remaining > 0
      # then this goes around the board
      # put one in your home
      remaining -= 1
      self.score += 1
      if remaining > 0
        opponent.pits[0, remaining]=self.pits[0, remaining].map!{|t| t += 1}
      else
        unless self.pits.inject(:+) == 0
          instrument("You get another turn!", display)
          self.move(opponent, self.pick_pit(opponent), display)
        end
      end
    else
      # ending on this side of the board... gotta check empty
      # going to be a 1 if capture, because you've already put down the rest of the pieces
      if self[pit+range-1] == 1
        instrument("Empty! #{self} captures!", display)
        self.score += opponent[-1 * (pit+range)]
        opponent.pits[-1 * (pit+range)] = 0
      end
    end
  end

  def [] n
    @pits[n]
  end

  def []= n, a
    @pits[n] = a
  end
  
  def engine_eval(opponent)
    @engine.move(self, opponent)
  end
  
  def clone
    clone = self.dup
    clone.score = @score
    clone.pits = @pits.clone
    return clone
  end

  def to_s
    if human
      "Player #{number}"
    else
      @engine.name
    end
  end
end

class Mancala
  @p1
  @p2
  @gameover
  attr_accessor :p1, :p2
  attr_reader :gameover

  def initialize(p1, p2)
    @p1, @p2 = p1, p2
  end



  def play
    # this should be the game loop
    # you should check for moves, then check to see if game has ended
    player, opponent = @p1, @p2

    until @gameover
      # prompt player
      player.move(opponent, player.pick_pit(opponent), true)
      @gameover = true if player.pits.inject(:+)==0 or opponent.pits.inject(:+)==0
      # switch positions
      puts self
      player, opponent = opponent, player
    end

    # TODO refactor this
    instrument(self, true)
    if @p1.score > @p2.score
      puts "P1 (#{@p1}) wins with #{@p1.score} to #{@p2.score}!"
    elsif @p2.score > @p1.score
      puts "P2 (#{@p2}) wins with #{@p2.score} to #{@p1.score}!"
    else
      puts "It's a tie! Everybody wins!"
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
      p2h_b = p2h_b + " "
    end
    # TODO colorate this?
    "\n        6 5 4 3 2 1  \n    +-----------------+\n    |  #{p2s[6]} #{p2s[5]} #{p2s[4]} #{p2s[3]} #{p2s[2]} #{p2s[1]} #{p2s[0]}   |\n  P#{@p1.number}| #{p2h_b}           #{p1h_b} |P#{@p2.number}\n    |   #{p1s[0]} #{p1s[1]} #{p1s[2]} #{p1s[3]} #{p1s[4]} #{p1s[5]} #{p1s[6]}  |\n    +-----------------+\n        1 2 3 4 5 6\n\n"
  end
end

class Game
  @game
  attr_accessor :game
  # this method either takes two integers on run, or will prompt for values on game start
  def initialize
    puts ".  . .-. . . .-. .-. .   .-. \n |\/| |-| |\| |   |-| |   |-| \n'  ` ` ' ' ` `-' ` ' `-' ` ' "
    puts "============================"
    if ARGV.size == 0
      puts "Enter AI level of Player 1: (0 for human player up to 3)"
      ainum = gets.chomp!
      until 0.upto(3).include?(ainum.to_i)
        puts "whoops, try again:\n"
        ainum = gets.chomp!
      end
      @p1 = Player.new(1, ainum.to_i)

      puts "Enter AI level of Player 2: (0 for human player up to 3)"
      ainum = gets.chomp!
      until 0.upto(3).include?(ainum.to_i)
        puts "whoops, try again:\n"
        ainum = gets.chomp!
      end
      @p2 = Player.new(2, ainum.to_i)
    else
      if 0.upto(3).include?(ARGV[0].to_i) and 0.upto(3).include?(ARGV[1].to_i)
        @p1 = Player.new(1, ARGV[0].to_i)
        @p2 = Player.new(2, ARGV[1].to_i)
      else
        puts "only put in two integers, from 0 to 3"
        exit
      end
    end
    @game = Mancala.new(@p1, @p2)
    puts "#{@p1} vs. #{@p2}! Go!"
  end

  # TODO fix this awful
  def play
    @game.play
  end
end

game = Game.new
game.play
