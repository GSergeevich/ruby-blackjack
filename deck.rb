SUITS = %w[♠ ♥ ♦ ♣].freeze
VALUES = [2, 3, 4, 5, 6, 7, 8, 9, [10, 'J', 'Q', 'K'], 'A'].freeze

class Deck
  attr_accessor :deck

  def initialize
    unpack
    self
  end

  def steer!
    @deck.shuffle!
  end

  private

  def unpack
    @deck = []
    SUITS.each do |suit|
      VALUES.each.with_index(2) do |value, index|
        if value.instance_of?(Array)
          value.each { |value| @deck << { suit: suit, value: value, score: [index] } }
        else
          @deck << if value == 'A'
                     { suit: suit, value: value, score: [index, 1] }
                   else
                     { suit: suit, value: value, score: [index] }
                   end
        end
      end
    end
  end
end
