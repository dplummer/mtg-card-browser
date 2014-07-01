class AddUnaccentIndexToCardName < ActiveRecord::Migration
  def change
    execute <<-SQL
CREATE OR REPLACE FUNCTION f_unaccent(text)
  RETURNS text AS
$func$
SELECT unaccent('unaccent', $1)
$func$  LANGUAGE sql IMMUTABLE SET search_path = public, pg_temp;
SQL
    execute "create index cards_unaccented_name on cards(f_unaccent(name))"
  end
end
