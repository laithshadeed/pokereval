RSpec.describe PokerEval do
  it 'has a version number' do
    expect(PokerEval::VERSION).not_to be nil
  end

  scenarios = [
    {name: 'Royal Flush',     str: 'KS JS TS QS AS', out: 'TS JS QS KS AS'},
    {name: 'Straight Flush',  str: 'AH 5H 2H 4H 3H', out: '2H 3H 4H 5H AH'},
    {name: 'Straight Flush',  str: '9D KD TD QD JD', out: '9D TD JD QD KD'}
  ]

  scenarios.each do |s|
    it "should construct hand from a string of #{s[:str]}" do
      expect(PokerEval::Hand.from_string(s[:str]).to_s)
        .to eq("<hand [#{s[:out]}], '#{s[:name]}'>")
    end
  end

  it 'get hand value' do
    expect(PokerEval::Hand.from_string('TS JS QS KS AS').name)
      .to eq('Royal Flush')
  end

  it 'should assert ROYAL_FLUSH > STRAIGHT_FLUSH' do
    expect(PokerEval::Hand.from_string('TS JS QS KS AS'))
      .to be > PokerEval::Hand.from_string('5S 6S 7S 8S 9S')
  end

  it 'should assert FULL_HOUSE < FOUR_OF_A_KIND' do
    expect(PokerEval::Hand.from_string('5H 5C QD QC QS'))
      .to be < PokerEval::Hand.from_string('7S TC TH TS TD')
  end

  it 'should sort hands with different rank' do
    hands = [
      PokerEval::Hand.from_string('2D 3D 7D QD AD'),    # FLUSH
      PokerEval::Hand.from_string('5S 6S 7S 8S 9S'),    # STRAIGHT_FLUSH
      PokerEval::Hand.from_string('TS JS QS KS AS'),    # ROYAL_FLUSH
      PokerEval::Hand.from_string('5H 5C QD QC QS'),    # FULL_HOUSE
      PokerEval::Hand.from_string('7S TC TH TS TD'),    # FOUR_OF_A_KIND
      PokerEval::Hand.from_string('4D 5D 6D 7H 8D')     # STRAIGHT
    ]

    expect(hands.sort.join(' '))
      .to eq [
        "<hand [4D 5D 6D 7H 8D], 'Straight'>",
        "<hand [2D 3D 7D QD AD], 'Flush'>",
        "<hand [5H 5C QD QC QS], 'Full House'>",
        "<hand [7S TC TH TS TD], 'Four Of A Kind'>",
        "<hand [5S 6S 7S 8S 9S], 'Straight Flush'>",
        "<hand [TS JS QS KS AS], 'Royal Flush'>"
      ].join(' ')
  end
end
