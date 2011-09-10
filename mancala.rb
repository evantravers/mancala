require 'pp'

class Mancala
  @p1s
  @p2s
  @p1h
  @p2h
  attr_reader :p1s, :p2s, :p1h, :p2h
  @gameover

  def initialize(numpits=6, numpieces=3)
    # create the arrays and fill them in w/ proper # of pieces.
    @p1s=Array.new(numpits).map{|slot| slot = numpieces}
    @p2s=Array.new(numpits).map{|slot| slot = numpieces}
    @p1h = 0
    @p2h = 0
    @gameover = false
  end

  def move(player, pit)
    # going to be a value between 1 and numpieces
    puts "moving player #{player}'s pit \##{pit}"
    pit=pit.to_i
    # TODO I hate this 
    if player == "p1h"
      remaining = @p1s[pit-1]
      puts remaining
      @p1s[pit-1]=0
      @p1s[pit, remaining]=@p1s[pit, remaining].map!{|t| t += 1}
      # subtract the items you have dropped
      remaining = remaining - @p1s[pit..-1].size
      if remaining > 0
        # put one in your home
        remaining -= 1
        @p1h += 1
        if remaining > 0
          @p2s[0, remaining]=@p1s[0, remaining].map!{|t| t += 1}
        end
      end
    else
      remaining = @p2s[pit-1]
      @p2s[pit-1]=0
      @p2s[pit, remaining]=@p2s[pit, remaining].map!{|t| t += 1}
      remaining = remaining - @p2s[pit..-1].size
      if remaining > 0 
        # put one in your home
        remaining -= 1
        @p2h += 1
        if remaining > 0
          @p1s[0, remaining]=@p1s[0, remaining].map!{|t| t += 1}
        end
      end
    end
  end

  def game
    # this should be the game loop
    # you should check for moves, then check to see if game has ended
    p = 1
    until @gameover
      # TODO I don't like the player selection code here
      # prompt player
      puts self
      puts "Player #{p}, enter your move!"
      move("p#{p}h", gets.chomp!)
      @gameover = true if @p1s.inject(:+)==0 or @p2s.inject(:+)==0
      # TODO there must be a more elegant way to play this
      if p==1
        p=2
      else
        p=1
      end
    end
  end

  def to_s
    "\t#{p2s[6]} #{p2s[5]} #{p2s[4]} #{p2s[3]} #{p2s[2]} #{p2s[1]} #{p2s[0]} \t\n\t#{p2h}           #{p1h}\n\t #{p1s[0]} #{p1s[1]} #{p1s[2]} #{p1s[3]} #{p1s[4]} #{p1s[5]} #{p1s[6]} \t\n\n"
  end
end

b = Mancala.new
b.game
