class CreateMtgSetIcons < ActiveRecord::Migration
  def change
    create_table :mtg_set_icons do |t|
      t.integer :mtg_set_id
      t.index :mtg_set_id
      t.foreign_key :mtg_sets, dependent: :delete
      t.string :filename
      t.index :filename, unique: true
      t.string :rarity

      t.timestamps
    end
  end
end
