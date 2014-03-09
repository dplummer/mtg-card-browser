class CardSearch
  attr_reader :query

  def initialize(query)
    @query = query
  end

  def cards
    cards = Card.where("name ILIKE ?", "%#{query}%").
      order("name ASC")

    MtgCard.decorate_cards(cards)
  end
end
