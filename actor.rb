require_relative 'game'

class Actor
  TURN_OPTIONS = [{description: 'Пропустить ход', method: 'pass_turn'},
                  {description: 'Ещё карту', method: 'handover_request'},
                  {description: 'Открыть карты', method: 'show_cards'}]

  attr_accessor :name, :cash, :score, :hand 

  def initialize(name)
    @name = name
    @cash = 100
    @score = 0
    @hand = []
  end
end
