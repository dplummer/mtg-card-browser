class CcMarketPrice < ActiveRecord::Base
  self.primary_key = :cc_id
  belongs_to :printing, primary_key: :cc_id, foreign_key: :cc_id

  def self.warp_import(cc_id, market_price)
    if market_price
      upsert(cc_id, market_price)
    end
  end

  def self.upsert(cc_id, market_price)
    ccmp = find_or_initialize_by(cc_id: cc_id)

    ccmp.avg    = market_price.avg * 100
    ccmp.high   = market_price.high * 100
    ccmp.low    = market_price.low * 100
    ccmp.max    = market_price.max * 100
    ccmp.median = market_price.median * 100
    ccmp.min    = market_price.min * 100
    ccmp.stdev  = market_price.stdev * 100

    ccmp.save
  end
end
