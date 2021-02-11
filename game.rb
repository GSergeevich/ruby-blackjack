require_relative 'actor'
require_relative 'deck'
require_relative 'interface'

class Game

  TURN_OPTIONS = [{ description: 'Пропустить ход', method: 'pass_turn' },
                  { description: 'Ещё карту', method: 'handover' },
                  { description: 'Открыть карты', method: 'show_cards' }].freeze

  attr_accessor :bank, :deck, :player, :dealer, :message

  def initialize
    @interface = Interface.new
    @player = player_init
    @dealer = dealer_init
    @bank = 0
    @message = ''
    start_game
  end

  def start_game
    @deck = Deck.new
    @deck.steer!
    handover('player', 2)
    handover('dealer', 2)
    bet('player', 10)
    bet('dealer', 10)
    make_turn('player')
  end

  def end_game
    input = @interface.draw_end_game
    case input
    when '1'
      start_game
    else
      exit
    end
  end

  def player_init
    name = @interface.draw_init
    Actor.new(name)
  end

  def dealer_init
    Actor.new('Дилер')
  end

  def make_turn(actor)
    @message += "Ход делает #{eval("@#{actor}.name")}\n"
    sleep 1
    @interface.draw_state(self)
    @player.hand.length == 3 && @dealer.hand.length == 3 ? show_cards : true
    if actor == 'player'
      TURN_OPTIONS.each.with_index(1) { |value, index| puts "#{index}) #{value[:description]}" }
      input = gets.chomp
      case input
      when '1'
        pass_turn(actor)
      when '2'
        eval("@#{actor}.hand.length") == 2 ? (handover(actor, 1); pass_turn(actor)) : (@message = "У вас должно быть две карты.\n"; pass_turn(actor))
      when '3'
        show_cards
      end
    else
      eval("@#{actor}.score") < 17 ? handover(actor, 1) : pass_turn(actor)
      pass_turn(actor)
    end
  end

  def pass_turn(actor)
    actor == 'player' ? make_turn('dealer') : make_turn('player')
  end

  def show_cards
    payout(choose_winner)
    @interface.draw_full_state(self)
    @player.hand = []
    @dealer.hand = []
    end_game
  end

  def not_bust?(number)
    number <= 21 ? number : nil 
  end

  def choose_winner
    if @player.score != @dealer.score
      not_bust?(@player.score).to_i > not_bust?(@dealer.score).to_i ? 'player' : 'dealer'
    else
      false
    end
  end

  def handover(actor, number)
    eval("@#{actor}.hand.concat(@deck.deck.pop(#{number}))")
    eval("@#{actor}.hand.sort_by! {|card| card[:score].max}")
    eval("@#{actor}.score = @#{actor}.hand.reduce(0) {|m,card| not_bust?(card[:score].max + m) ? card[:score].max + m : card[:score].min + m }")
    not_bust?(eval("@#{actor}.score")) ? true : (@message += "Перебор у #{eval("@#{actor}.name")}!\n"; show_cards) 
  end

  def bet(actor, number)
    eval("@#{actor}.cash -= #{number}") < 0 ? (@interface.draw_bet_fail(self, actor); exit) : @bank += number
  end

  def payout(actor)
    if actor
      eval("@#{actor}.cash += @bank")
      @message += "#{eval("@#{actor}.name")} выиграл!\n"
      @bank = 0
    else
      pay = (@bank / 2)
      @dealer.cash += pay
      @player.cash += pay
      @message += "Ничья!\n"
      @bank = 0
    end
  end
end
