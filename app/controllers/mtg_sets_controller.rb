class MtgSetsController < ApplicationController
  def index
    @sets = MtgSet.order("release_date DESC").eager_load(:mtg_set_icons).to_a
  end

  def show
    @set = MtgSet.find_by code: params[:set_code]
    @cards = MtgCard.find_all_for_set(@set)
  end
end
