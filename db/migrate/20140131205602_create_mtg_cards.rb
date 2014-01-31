class CreateMtgCards < ActiveRecord::Migration
  def change
    create_table :mtg_cards do |t|
      t.integer :mtg_set_id
      t.foreign_key :mtg_sets
      t.string :name
      t.string :names, :array => true
      t.string :mana_cost
      t.integer :cmc
      t.string :colors, :array => true
      t.string :type_text
      t.string :supertypes, :array => true
      t.string :card_types, :array => true
      t.string :subtypes, :array => true
      t.string :rarity
      t.text :text
      t.text :flavor
      t.string :artist
      t.integer :card_number
      t.string :power
      t.string :toughness
      t.string :layout
      t.integer :multiverse_id
      t.integer :multiverse_variation_ids, :array => true
      t.string :mtgimage_name
      t.string :watermark
      t.string :border
      t.integer :vanguard_hand_modifier
      t.integer :vanguard_life_modifier
      t.hstore :rulings
      t.hstore :foreign_names
      t.string :printings, :array => true

      t.timestamps
    end
  end
end
