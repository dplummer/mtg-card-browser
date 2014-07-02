class CreateProductSalePoints < ActiveRecord::Migration
  def change
    create_table :product_sale_points do |t|
      t.date :date
      t.integer :cc_id
      t.integer :sell_price_cents
      t.index :cc_id
    end
  end
end
