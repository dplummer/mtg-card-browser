class CreateFunctionColorlessManaCost < ActiveRecord::Migration
  def up
    execute(<<-SQL)
    CREATE OR REPLACE FUNCTION colorless_mana_cost(text) RETURNS int AS $$
    SELECT CAST((regexp_matches($1,'{(\d+)}'))[1] AS int);
    $$ LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT;
    SQL
  end
end
