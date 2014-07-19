class CreateCcMarketPrices < ActiveRecord::Migration
  def change
    create_table :cc_market_prices, id: false do |t|
      t.integer :cc_id, null: false, primary: true

      t.integer :avg, null: false
      t.integer :high, null: false
      t.integer :low, null: false
      t.integer :max, null: false
      t.integer :median, null: false
      t.integer :min, null: false
      t.integer :stdev, null: false

      t.timestamps
    end
  end
end
