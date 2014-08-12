class CardSearch
  COLOR_LOOKUP = {
    'w' => 'White',
    'u' => 'Blue',
    'b' => 'Black',
    'r' => 'Red',
    'g' => 'Green',
  }.freeze

  attr_reader :query

  def initialize(query)
    @query = query
  end

  def cards
    cards = CardSearch::Parser.new(query).scope.
      order("name ASC").
      limit(25)

    MtgCard.decorate_cards(cards)
  end
end
