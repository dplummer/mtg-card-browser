class AddIndexToSortOrder < ActiveRecord::Migration
  def change
    change_column :printings, :sort_order, :integer, null: false, default: nil
    add_index :printings, [:edition_id, :sort_order], unique: true
    remove_index :printings, :edition_id
  end
end
