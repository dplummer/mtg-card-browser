class CreateEditions < ActiveRecord::Migration
  def change
    create_table :editions do |t|
      t.integer :card_id
      t.foreign_key :cards, dependent: :delete

      t.integer :mtg_set_id
      t.foreign_key :mtg_sets, dependent: :delete

      t.text :flavor
      t.string :border
      t.string :watermark
      t.string :rarity

      t.timestamps
    end
    add_index "editions", "mtg_set_id"
    add_index "editions", "card_id"
  end
end
