class MtgSetsController < ApplicationController
  def index
    @sets = MtgSet.all
  end

  def show
    @set = MtgSet.find_by code: params[:set_code]
    @cards = MtgCard.find_all_for_set(@set)
  end
end
