class AddCcIdToPrinting < ActiveRecord::Migration
  def change
    add_column :printings, :cc_id, :integer
  end
end
