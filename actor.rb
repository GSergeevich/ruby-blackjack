class Actor
  attr_accessor :name, :cash, :hand 

  def initialize(name)
    @name = name
    @cash = 100
    @hand = []
  end

  def make_turn
      
  end
 
end

class Dealer < Actor

end
