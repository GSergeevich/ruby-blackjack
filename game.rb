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
    start_game
  end

  def start_game
    deck.steer!
    handover('player',2)
    handover('dealer',2)
    bet('player',10)
    bet('dealer',10)
    make_turn('player')
  end

  def end_game
    p "end game"
    exit 
  end

  def draw_state(*args)
    player_hand = @player.hand.map {|card| card[:value].to_s + card[:suit]}
    dealer_hand = args.empty? ? @dealer.hand.map {'* '} : @dealer.hand.map {|card| card[:value].to_s + card[:suit]}
    dealer_score = args.empty? ? "*" : @dealer.score 
    puts "#{@player.name}: #{player_hand} Score: #{@player.score} Cash: #{@player.cash}" 
    puts "Dealer: #{dealer_hand} Score: #{dealer_score} Cash: #{@dealer.cash}" 
    puts "Bank: #{@bank}"
  end
  
  def player_init
    puts "Добро пожаловать в игру!Как ваше имя?"
    name = gets.chomp
    Actor.new(name)
  end  

  def dealer_init
    Actor.new("Dealer")
  end  

  def make_turn(actor)
    draw_state
    p actor
    @player.hand.length == 3 && @dealer.hand.length == 3 ? show_cards : true
    @player.score == 3 && @dealer.hand.length == 3 ? show_cards : true
    if actor == 'player'
      TURN_OPTIONS.each.with_index(1) {|value,index| puts "#{index}) #{value[:description]}" }
      input = gets.chomp
      case input
      when '1'
        pass_turn(actor)
      when '2'
        eval("@#{actor}.hand.length") == 2 ? (handover(actor,1);pass_turn(actor)) : (puts "У вас должно быть две карты"; pass_turn(actor))
      when '3'
        show_cards
      end
    else   
      puts eval("@#{actor}.score") < 17 ? handover(actor,1) : pass_turn(actor)
      pass_turn(actor)
    end
  end

  def pass_turn(actor)
    actor == 'player' ? make_turn('dealer') : make_turn('player')
  end

  def show_cards
    payout(choose_winner) 
    draw_state(1)
    end_game
  end
  
  def choose_winner
    @player.score > @dealer.score ? 'player' : 'dealer' 
  end
  
  def handover(actor,number)
    eval("@#{actor}.hand.concat(@deck.deck.pop(#{number}))")
    eval("@#{actor}.score = @#{actor}.hand.reduce(0) {|m,card| card[:score] + m }") 
    eval("@#{actor}.score") > 21 ? (puts "Перебор!"; show_cards) : true
  end
  
  def bet(actor,number)
    eval("@#{actor}.cash -= #{number}")
    @bank += number
  end
  
  def payout(actor)
    eval("@#{actor}.cash += @bank")
  end

end
