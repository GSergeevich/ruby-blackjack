class Interface

  TURN_OPTIONS = [{ description: 'Пропустить ход', method: 'pass_turn' },
                  { description: 'Ещё карту', method: 'handover' },
                  { description: 'Открыть карты', method: 'show_cards' }].freeze

  def draw_init
    puts 'Добро пожаловать в игру!Как ваше имя?'
    gets.chomp
  end
  
  def draw_turn_options
    TURN_OPTIONS.each.with_index(1) { |value, index| puts "#{index}) #{value[:description]}" }
    gets.chomp   
  end

  def draw_state(game)
    system 'clear'
    puts game.message
    game.message = ''
    player_hand = game.player.hand.map { |card| card[:value].to_s + card[:suit] }
    dealer_hand = game.dealer.hand.map { '* ' }
    puts "#{game.player.name}: #{player_hand} Score: #{game.player.score} Cash: #{game.player.cash}"
    puts "#{game.dealer.name}: #{dealer_hand} Score: \"*\" Cash: #{game.dealer.cash}"
    puts "Банк: #{game.bank}"
    puts '--------'
  end

  def draw_full_state(game)
    system 'clear'
    puts game.message
    game.message = ''
    player_hand = game.player.hand.map { |card| card[:value].to_s + card[:suit] }
    dealer_hand = game.dealer.hand.map { |card| card[:value].to_s + card[:suit] }
    puts "#{game.player.name}: #{player_hand} Score: #{game.player.score} Cash: #{game.player.cash}"
    puts "#{game.dealer.name}: #{dealer_hand} Score: #{game.dealer.score} Cash: #{game.dealer.cash}"
    puts "Банк: #{game.bank}"
    puts '--------'
  end

  def draw_end_game
    puts <<~INPUT
      1)Сыграть ещё раз
      2)Выход
    INPUT
    gets.chomp
  end

  def draw_bet_fail(game, actor)
    name = eval("game.#{actor}.name")
    p name
    puts "У #{name}a не хватает денег.Игра окончена."
  end
end
