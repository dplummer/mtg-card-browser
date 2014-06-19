class CardSearch
  attr_reader :query

  def initialize(query)
    @query = query
  end

  def cards
    cards = Card.where("name ILIKE ?", "%#{query}%").
      order("name ASC").
      limit(10)

    MtgCard.decorate_cards(cards)
  end
end
