class AddOtherPrintingIdToPrintings < ActiveRecord::Migration
  def change
    add_column :printings, :other_printing_id, :integer
    add_index :printings, :other_printing_id
  end
end
