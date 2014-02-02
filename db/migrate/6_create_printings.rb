class CreatePrintings < ActiveRecord::Migration
  def change
    create_table :printings do |t|
      t.integer :edition_id
      t.foreign_key :editions, dependent: :delete

      t.integer :multiverse_id
      t.string :mtgimage_name
      t.integer :number
      t.string :artist

      t.timestamps
    end
    add_index "printings", "edition_id"
  end
end
