class MtgCardsController < ApplicationController
  def show
    @card = MtgCard.find params[:id]
  end
end
