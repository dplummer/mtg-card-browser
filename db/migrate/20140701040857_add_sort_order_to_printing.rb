class AddSortOrderToPrinting < ActiveRecord::Migration
  def change
    add_column :printings, :sort_order, :integer, null: false, default: 0
  end
end
