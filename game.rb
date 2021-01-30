require_relative 'actor'
require_relative 'deck'
require 'pry'

class Game
  attr_accessor :bank, :deck  

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
    #validate name
    Actor.new(name)
  end  

  def dealer_init
    Dealer.new("Dealer")
  end  
  
  def handover(number)
    @player.hand.concat(@deck.deck.pop(number))
    @dealer.hand.concat(@deck.deck.pop(number))
  end
  
  def bet(number)
    @player.cash -= number
    @dealer.cash -= number
    @bank += (number * 2)
  end

end
