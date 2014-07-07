class AddLowerFunctionForArrays < ActiveRecord::Migration
  def change
    execute(<<-SQL)
CREATE OR REPLACE FUNCTION lower(text[]) RETURNS text[] LANGUAGE SQL IMMUTABLE AS
$$
SELECT array_agg(lower(value)) FROM unnest($1) value;
$$;
    SQL
  end
end
