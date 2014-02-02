class CreateRulings < ActiveRecord::Migration
  def change
    create_table :rulings do |t|
      t.date :date
      t.text :text
      t.integer :card_id
      t.foreign_key :cards, dependent: :delete

      t.timestamps
    end
    add_index "rulings", "card_id"
  end
end
