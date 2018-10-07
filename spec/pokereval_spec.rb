RSpec.describe PokerEval do
  it 'has a version number' do
    expect(PokerEval::VERSION).not_to be nil
  end

  it 'get hand string' do
    expect(PokerEval::Hand.from_string('TS JS QS KS AS', 9).to_s)
      .to eq("<hand [TS JS QS KS AS], 'Royal Flush'>")
  end

  it 'get hand value' do
    expect(PokerEval::Hand.from_string('TS JS QS KS AS', 9).value)
      .to eq(:ROYAL_FLUSH)
  end

  it 'assert ROYAL_FLUSH > STRAIGHT_FLUSH' do
    expect(PokerEval::Hand.from_string('TS JS QS KS AS', 9))
      .to be > PokerEval::Hand.from_string('5S 6S 7S 8S 9S', 8)
  end

  it 'assert FULL_HOUSE < FOUR_OF_A_KIND' do
    expect(PokerEval::Hand.from_string('5H 5C QD QC QS', 6))
      .to be < PokerEval::Hand.from_string('7S, TC, TH, TS, TD', 7)
  end

  it 'allow sorting hands' do
    hands = [
      PokerEval::Hand.from_string('5S 6S 7S 8S 9S', 8), # STRAIGHT_FLUSH
      PokerEval::Hand.from_string('TS JS QS KS AS', 9), # ROYAL_FLUSH
      PokerEval::Hand.from_string('5H 5C QD QC QS', 6), # FULL_HOUSE
      PokerEval::Hand.from_string('7S, TC, TH, TS, TD', 7) # FOUR_OF_A_KIND
    ]

    expect(hands.sort.join(' '))
      .to eq [
        "<hand [5H 5C QD QC QS], 'Full House'>",
        "<hand [7S, TC, TH, TS, TD], 'Four Of A Kind'>",
        "<hand [5S 6S 7S 8S 9S], 'Straight Flush'>",
        "<hand [TS JS QS KS AS], 'Royal Flush'>"
      ].join(' ')
  end
end
