require_relative 'actor'
require_relative 'deck'
require 'pry'

class Game
  TURN_OPTIONS = [{description: 'Пропустить ход', method: 'pass_turn'},
                  {description: 'Ещё карту', method: 'handover'},
                  {description: 'Открыть карты', method: 'show_cards'}]

  attr_accessor :bank, :deck , :player , :dealer 

  def initialize
    @player = player_init
    @dealer = dealer_init
    @bank = 0
    @deck = Deck.new
  end

  def draw_state
    player_hand = @player.hand.map {|card| card[:value].to_s + card[:suit]}
    dealer_hand = @dealer.hand.map {'* '} 
    puts "#{@player.name}: #{player_hand} Score: #{@player.hand.reduce(0) {|m,card| card[:score] + m }} Cash: #{@player.cash}" 
    puts "Dealer: #{dealer_hand} Cash: #{@dealer.cash}" 
    puts "Bank: #{@bank}" 
  end
  
  def player_init
    puts "Добро пожаловать в игру!Как ваше имя?"
    name = gets.chomp
    Actor.new(name)
  end  

  def dealer_init
    Dealer.new("Dealer")
  end  

  def make_turn(actor)
    p actor
    TURN_OPTIONS.each.with_index(1) {|value,index| puts "#{index}) #{value[:description]}" }
    input = gets.chomp
    case input
    when '1'
      pass_turn(actor)
    when '2'
      
    end
  end

  def pass_turn(actor)
    actor == 'player' ? make_turn('dealer') : make_turn('player')
  end

  def show_cards
    show_cards
  end

  
  def handover(actor,number)
    eval("@#{actor}.hand.concat(@deck.deck.pop(#{number}))")
  end
  
  def bet(number)
    @player.cash -= number
    @dealer.cash -= number
    @bank += (number * 2)
  end

end
