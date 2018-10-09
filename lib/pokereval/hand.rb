module PokerEval
  class Hand
    include Comparable

    attr_accessor :hand, :hand_str, :name, :rank, :weight

    def self.from_string(str)
      Hand.new(str)
    end

    def initialize(str)
      self.hand_str = str
      self.hand = str
      self.rank = hand
      self.weight = rank
      self.name = rank
    end

    def <=>(other)
      @weight <=> other.weight
    end

    def to_s
      "<hand [#{@hand_str}], '#{@name}'>"
    end

    def hand=(str)
      @hand = str
        .upcase.split(' ')
        .map(&method(:parse_card))
        .sort_by! { |c| [c[:value], c[:suite]] }
    end

    # @TODO:
    # - This function does not always yield correct weight when same rank here a broken example:
    #   6H 5H 5S 9C 9H && AD 2C 2H JH JS
    # - It has very high Cognitive Complexity
    #
    # I'm relying on Cactus Kev's table http://suffe.cool/poker/7462.html to double check correctness
    # Possible solution to use Cactus Kev's binary scheme or to use prime number multiplication
    def weight=(rank)
      h = @hand.map { |c| c[:value] }.each_with_object(Hash.new(0)) { |o, hs| hs[o] += 1 }
      @weight =
        case rank
        when :ROYAL_FLUSH, :STRAIGHT_FLUSH then 8000 + @hand.map { |c| c[:value] }.inject(&:+)
        when :FOUR_OF_A_KIND then 7000 + 15 * 4 * h.key(4) + h.key(1)
        when :FULL_HOUSE then 6000 + 15 * 3 * h.key(3) + h.key(2)
        when :FLUSH then 5000 + @hand.map { |c| c[:value] }.inject(&:+)
        when :STRAIGHT then 4000 + @hand.map { |c| c[:value] }.inject(&:+)
        when :THREE_OF_A_KIND then 3000 + 15 * 3 * h.key(3) + h.map { |k, v| k if v == 1 }.compact.inject(&:+)
        when :TWO_PAIR then 2000 + 15 * 2 * h.map { |k, v| k if v == 2 }.compact.inject(&:+) + h.key(1)
        when :ONE_PAIR then 1000 + 15 * 2 * h.key(2) + h.map { |k, v| k if v == 1 }.compact.inject(&:+)
        when :HIGH_CARD then @hand.map { |c| c[:value] }.inject(&:+)
        end
    end

    def name=(rank)
      @name = rank.to_s.split('_').collect(&:capitalize).join(' ')
    end

    def rank=(hand)
      (f5, f4, f3, f2, f1) = hand.map { |c| c[:face] }
      count_hash = [f5, f4, f3, f2, f1].each_with_object(Hash.new(0)) { |o, h| h[o] += 1 }
      @rank =
        if straight?
          if flush?
            f1 == :A && f2 == :K ? :ROYAL_FLUSH : :STRAIGHT_FLUSH
          else
            :STRAIGHT
          end
        elsif count_hash.map { |k, v| k if v == 4 }.compact.count == 1
          :FOUR_OF_A_KIND
        elsif count_hash.map { |k, v| k if v == 3 }.compact.count == 1 &&
              count_hash.map { |k, v| k if v == 2 }.compact.count == 1
          :FULL_HOUSE
        elsif f1 != f2 && f2 != f3 && f3 != f4 && f4 != f5 && flush?
          :FLUSH
        elsif count_hash.map { |k, v| k if v == 3 }.compact.count == 1
          :THREE_OF_A_KIND
        elsif count_hash.map { |k, v| k if v == 2 }.compact.count == 2
          :TWO_PAIR
        elsif count_hash.map { |k, v| k if v == 2 }.compact.count == 1
          :ONE_PAIR
        else
          :HIGH_CARD
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
      {face: parse_rank(val), suite: suite.to_sym, value: parse_value(val)}
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
