class AddUnaccentExtension < ActiveRecord::Migration
  def up
    execute "CREATE EXTENSION unaccent"
  end

  def up
    execute "DROP EXTENSION unaccent"
  end
end
