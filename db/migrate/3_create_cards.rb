class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :name
      t.string :names, :array => true
      t.string :mana_cost
      t.integer :cmc
      t.string :colors, :array => true
      t.string :type_text
      t.string :supertypes, :array => true
      t.string :card_types, :array => true
      t.string :subtypes, :array => true
      t.text :text
      t.string :power
      t.string :toughness
      t.string :layout
      t.integer :vanguard_hand_modifier
      t.integer :vanguard_life_modifier
      t.hstore :foreign_names

      t.timestamps
    end
  end
end
