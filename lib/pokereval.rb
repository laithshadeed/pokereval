require "pokereval/version"
require "pokereval/hand"

module PokerEval
  class << self
    def run(str)
      puts Hand.from_string(str)
    end
  end
end
