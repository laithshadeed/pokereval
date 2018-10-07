module PokerEval
  class Hand
    include Comparable

    attr_reader :value, :weight

    VALUES = %i[HIGH_CARD ONE_PAIR TWO_PAIR TREE_OF_A_KIND STRAIGHT FLUSH FULL_HOUSE FOUR_OF_A_KIND STRAIGHT_FLUSH ROYAL_FLUSH]

    def self.from_string(str, val)
      Hand.new(str.split(' '), val)
    end

    def initialize(cards, val)
      @cards = cards
      @value = VALUES[val]
      @weight = val
    end

    def <=>(other)
      weight <=> other.weight
    end

    def to_s
      "<hand [#{@cards.join(' ')}], '#{@value.to_s.split('_').collect(&:capitalize).join(' ')}'>"
    end
  end
end
