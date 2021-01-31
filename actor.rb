require_relative 'game'

class Actor
  TURN_OPTIONS = [{description: 'Пропустить ход', method: 'pass_turn'},
                  {description: 'Ещё карту', method: 'handover_request'},
                  {description: 'Открыть карты', method: 'show_cards'}]

  attr_accessor :name, :cash, :hand , :role

  def initialize(name)
    @role = 'player'
    @name = name
    @cash = 100
    @hand = []
  end

  def make_turn
    TURN_OPTIONS.each.with_index(1) {|value,index| puts "#{index}) #{value[:description]}" }
    input = gets.chomp.to_i
    eval("#{TURN_OPTIONS[input - 1][:method]}")
  end

  def pass_turn
    exit
  end
  
  def handover_request
    game.handover(@role,1)
    pass_turn
  end
  
  def show_cards
    game.show_cards
  end

end

class Dealer < Actor
  def initialize(name)
    super(name)
    @role = 'dealer'
  end

  def make_turn
  end
end
