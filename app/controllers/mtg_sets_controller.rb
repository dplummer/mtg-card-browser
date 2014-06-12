class MtgSetsController < ApplicationController
  respond_to :html, :json

  def index
    @sets = MtgSet.order("release_date DESC").eager_load(:mtg_set_icons).to_a
    respond_with(@sets)
  end

  def show
    @set = MtgSet.find_by code: params[:set_code]
    @cards = MtgCard.find_all_for_set(@set)
    respond_with(@set)
  end
end
