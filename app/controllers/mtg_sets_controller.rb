class MtgSetsController < ApplicationController
  respond_to :html, :json

  def index
    @sets = MtgSet.order("release_date DESC").eager_load(:mtg_set_icons).to_a

    respond_to do |format|
      format.html
      format.json { render json: @sets, each_serializer: MtgSetMinSerializer }
    end
  end

  def show
    @set = MtgSet.find_by code: params[:set_code]
    respond_to do |format|
      format.html {
        @cards = MtgCard.find_all_for_set(@set)
      }
      format.json {
        respond_with(@set)
      }
    end
  end
end
