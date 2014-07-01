class ConvertCardNumberToString < ActiveRecord::Migration
  def change
    change_column "printings", "number", :string
  end
end
