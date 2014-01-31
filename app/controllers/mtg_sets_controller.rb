class MtgSetsController < ApplicationController
  def index
    @sets = MtgSet.all
  end

  def show
    @set = MtgSet.find params[:id]
    @cards = @set.mtg_cards.order('card_number ASC').to_a
  end
end
