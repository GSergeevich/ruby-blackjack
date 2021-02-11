require_relative 'game'

class Actor
  
  CASH = 100

  attr_accessor :name, :cash, :score, :hand

  def initialize(name)
    @name = name
    @cash = CASH
    @score = 0
    @hand = []
  end
end
