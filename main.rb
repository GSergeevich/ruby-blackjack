require_relative 'game'

game=Game.new
game.deck.steer!
game.handover(2)
#binding pry
game.bet(10)
game.draw_state

