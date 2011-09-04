require 'pp'

class Mancala
  @p1s
  @p2s
  @p1h
  @p2h
  attr_reader :p1s, :p2s, :p1h, :p2h

  def initialize(numpits=6, numpieces=3)
    # create the arrays and fill them in
    @p1s=Array.new(numpits).map{|slot| slot = numpieces}
    @p2s=Array.new(numpits).map{|slot| slot = numpieces}
  end

  def move(player, pit)
    # going to be a value between 1 and numpieces
    puts "moving player #{player}'s pit \##{pit}"
  end
end

b = Mancala.new
