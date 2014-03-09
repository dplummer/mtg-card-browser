class CardsController < ApplicationController
  def show
    if params[:card_number]
      @card = MtgCard.find card_number: params[:card_number], set_code: params[:set_code]
    else
      @card = MtgCard.find multiverse_id: params[:multiverse_id], set_code: params[:set_code]
    end
  end

  def search
    query = CardSearch.new(params)
    @cards = query.cards
  end
end
