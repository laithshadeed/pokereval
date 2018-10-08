module PokerEval
  class Hand
    include Comparable

    attr_accessor :hand, :name, :rank, :weight

    HAND_VALUES = %i[
      HIGH_CARD
      ONE_PAIR
      TWO_PAIR
      THREE_OF_A_KIND
      STRAIGHT
      FLUSH
      FULL_HOUSE
      FOUR_OF_A_KIND
      STRAIGHT_FLUSH
      ROYAL_FLUSH
    ].freeze

    def self.from_string(str)
      Hand.new(str)
    end

    def initialize(str)
      self.hand = str
      self.rank = hand
      self.weight = rank
      self.name = rank
    end

    def <=>(other)
      @weight <=> other.weight
    end

    def to_s
      "<hand [#{print}], '#{@name}'>"
    end

    def print
      @hand.map { |c| "#{c[:rank]}#{c[:suite]}" }
        .join(' ')
    end

    def hand=(str)
      @hand = str
        .upcase.split(' ')
        .map(&method(:parse_card))
        .sort! { |a, b| a[:value] <=> b[:value] }
    end

    def weight=(rank)
      @weight = HAND_VALUES.index(rank[0])
    end

    def name=(rank)
      @name = rank[0].to_s.split('_').collect(&:capitalize).join(' ')
    end

    def rank=(hand)
      (r5, r4, r3, r2, r1) = hand.map { |c| c[:rank] }

      @rank =
        if straight?
          r = r1 == :A && r2 == 5 ? 5 : r1
          if flush?
            r == :A ? [:ROYAL_FLUSH] : [:STRAIGHT_FLUSH, r]
          else
            [:STRAIGHT, r]
          end
        elsif r1 == r2 && r2 == r3 && r3 == r4
          [:FOUR_OF_A_KIND, r1, r5]
        elsif r1 == r2 && r2 == r3 && r4 == r5
          [:FULL_HOUSE, r1, r4]
        elsif r1 == r2 && r3 == r4 && r4 == r5
          [:FULL_HOUSE, r3, r1]
        elsif r1 && r2 && r2 != r3 && r3 != r4 && r4 != r5 && flush?
          [:FLUSH, r1, r2, r3, r4, r5]
        elsif r1 == r2 && r2 == r3
          [:THREE_OF_A_KIND, r1, r4, r5]
        elsif r1 == r2 && r3 == r4
          [:TWO_PAIR, r1, r3, r5]
        elsif r1 == r2
          [:ONE_PAIR, r1, r3, r4, r5]
        else
          [:HIGH_CARD, r1, r2, r3, r4, r5]
        end
    end

    def straight?
      (v5, v4, v3, v2, v1) = @hand.map { |c| c[:value] }
      (v1 == v2 + 1 || (v1 == 14 && v2 == 5)) && # The 14 & 5 to handle A5432 case
        (v2 == v3 + 1) && (v3 == v4 + 1) && (v4 == v5 + 1)
    end

    def flush?
      (s5, s4, s3, s2, s1) = @hand.map { |c| c[:suite] }
      s1 == s2 && s2 == s3 && s3 == s4 && s4 == s5
    end

    def parse_card(str)
      (val, suite) = str.each_char.to_a
      {rank: parse_rank(val), suite: suite.to_sym, value: parse_value(val)}
    end

    def parse_rank(str)
      case str
      when 'T', 'J', 'Q', 'K', 'A' then
        str.to_sym
      else
        str.to_i
      end
    end

    def parse_value(str)
      case str
      when 'A' then 14
      when 'K' then 13
      when 'Q' then 12
      when 'J' then 11
      when 'T' then 10
      else
        str.to_i
      end
    end
  end
end
