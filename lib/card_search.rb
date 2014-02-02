class CardSearch
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def cards
    cards = Card.where("name ILIKE ?", "%#{params[:q]}%").
      order("name ASC")

    MtgCard.decorate_cards(cards)
  end
end
