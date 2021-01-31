require_relative 'game'

game=Game.new
game.deck.steer!
game.handover('player',2)
game.handover('dealer',2)
#binding pry
game.bet(10)
game.draw_state
game.make_turn('player')
