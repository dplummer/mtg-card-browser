class CardsController < ApplicationController
  respond_to :html, :json

  def show
    if params[:card_number]
      @card = MtgCard.find card_number: params[:card_number],
                           set_code: params[:set_code]
    else
      @card = MtgCard.find multiverse_id: params[:multiverse_id],
                           set_code: params[:set_code]
    end
    respond_with(@card, serializer: MtgCardSerializer)
  end

  skip_before_filter :default_expires_in

  def search
    query = params[:q]
    search = CardSearch.new(query)
    @cards = search.cards
    respond_with(@cards, each_serializer: MtgCardSerializer)
  end

  def price_data
    price_rows = Rails.cache.fetch(request.path_info, expires_in: 24.hours, compress: true) {
      card = MtgCard.find card_number: params[:card_number],
        set_code: params[:set_code]
      data = PriceAndVolumeData.new(card)
      data.prices.map(&:to_row).to_json
    }
    render text: price_rows, content_type: 'application/json'
  end
end
