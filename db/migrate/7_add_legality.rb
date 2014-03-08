class AddLegality < ActiveRecord::Migration
  def change
    add_column "cards", "legality", :hstore, :null => false, :default => ''
  end
end
