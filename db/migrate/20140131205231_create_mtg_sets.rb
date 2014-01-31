class CreateMtgSets < ActiveRecord::Migration
  def change
    create_table :mtg_sets do |t|
      t.string :name
      t.string :code
      t.date :release_date
      t.string :border
      t.string :release_type
      t.string :block

      t.timestamps
    end
  end
end
