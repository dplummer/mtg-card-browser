class Printing < ActiveRecord::Base
  belongs_to :edition
  has_one :cc_market_price, foreign_key: :cc_id, primary_key: :cc_id
end
