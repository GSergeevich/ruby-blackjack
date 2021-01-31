require_relative 'game'

loop do 
  puts "21"
  game=Game.new
  puts <<~INPUT 
     1)Сыграть ещё раз
     2)Выход
  INPUT
  input = gets.chomp
  case input
  when '1'
    next
  else
    exit
  end
end
