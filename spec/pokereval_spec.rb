RSpec.describe PokerEval do
  it 'has a version number' do
    expect(PokerEval::VERSION).not_to be nil
  end

  scenarios = [
    {name: 'Royal Flush',     str: 'TS JS QS KS AS'},
    {name: 'Straight Flush',  str: 'AH 2H 3H 4H 5H'},
    {name: 'Four Of A Kind',  str: '5D 2C 2D 2H 2S'},
    {name: 'Four Of A Kind',  str: '2C 2D 2H 2S KD'},
    {name: 'Full House',      str: 'AC AD QC QH QS'},
    {name: 'Full House',      str: 'QC QH QS TC TD'},
    {name: 'Flush',           str: '8S 9S TS KS AS'},
    {name: 'Straight',        str: '3S 4D 5H 6C 7H'},
    {name: 'Three Of A Kind', str: '2S KD 8C 8D 8H'},
    {name: 'Three Of A Kind', str: '8C 8D 8H 5D 9K'},
    {name: 'Two Pair',        str: '8D 3S 3D 6C 6S'},
    {name: 'Two Pair',        str: '3S 3D 6C 6S AD'},
    {name: 'One Pair',        str: '7C TC JD 8D 8S'},
    {name: 'One Pair',        str: '7C 7C 4D 5D JS'},
    {name: 'High Card',       str: '2S 5D 6H 7C 9D'}
  ]

  scenarios.each do |s|
    it "should construct hand from a string of #{s[:str]}" do
      expect(PokerEval::Hand.from_string(s[:str]).to_s)
        .to eq("<hand [#{s[:str]}], '#{s[:name]}'>")
    end
  end

  it 'get hand value' do
    expect(PokerEval::Hand.from_string('TS JS QS KS AS').name)
      .to eq('Royal Flush')
  end

  it 'should assert ROYAL_FLUSH > STRAIGHT_FLUSH using ">" operator' do
    expect(PokerEval::Hand.from_string('TS JS QS KS AS'))
      .to be > PokerEval::Hand.from_string('5S 6S 7S 8S 9S')
  end

  it 'should assert FULL_HOUSE < FOUR_OF_A_KIND using "<" operator' do
    expect(PokerEval::Hand.from_string('5H 5C QD QC QS'))
      .to be < PokerEval::Hand.from_string('7S TC TH TS TD')
  end

  it 'should sort hands with different rank' do
    hands = [
      PokerEval::Hand.from_string('8D 3S 3D 6C 6S'),    # TWO_PAIR
      PokerEval::Hand.from_string('2D 3D 7D QD AD'),    # FLUSH
      PokerEval::Hand.from_string('7C TC JD 8D 8S'),    # ONE_PAIR
      PokerEval::Hand.from_string('5S 6S 7S 8S 9S'),    # STRAIGHT_FLUSH
      PokerEval::Hand.from_string('TS JS QS KS AS'),    # ROYAL_FLUSH
      PokerEval::Hand.from_string('5H 5C QD QC QS'),    # FULL_HOUSE
      PokerEval::Hand.from_string('7S TC TH TS TD'),    # FOUR_OF_A_KIND
      PokerEval::Hand.from_string('2S 5D 6H 7C 9D'),    # HIGH_CARD
      PokerEval::Hand.from_string('4D 5D 6D 7H 8D'),    # STRAIGHT
      PokerEval::Hand.from_string('2S KD 8C 8D 8H')     # THREE_OF_A_KIND
    ]

    expect(hands.sort.join(' '))
      .to eq [
        "<hand [2S 5D 6H 7C 9D], 'High Card'>",
        "<hand [7C TC JD 8D 8S], 'One Pair'>",
        "<hand [8D 3S 3D 6C 6S], 'Two Pair'>",
        "<hand [2S KD 8C 8D 8H], 'Three Of A Kind'>",
        "<hand [4D 5D 6D 7H 8D], 'Straight'>",
        "<hand [2D 3D 7D QD AD], 'Flush'>",
        "<hand [5H 5C QD QC QS], 'Full House'>",
        "<hand [7S TC TH TS TD], 'Four Of A Kind'>",
        "<hand [5S 6S 7S 8S 9S], 'Straight Flush'>",
        "<hand [TS JS QS KS AS], 'Royal Flush'>"
      ].join(' ')
  end
end
