class CardsController < ApplicationController
  def show
    @card = MtgCard.find params[:set_code], params[:language], params[:card_number]
  end

  def search
    query = CardSearch.new(params)
    @cards = query.cards
  end
end
