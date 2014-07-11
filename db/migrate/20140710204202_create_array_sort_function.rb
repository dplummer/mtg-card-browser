class CreateArraySortFunction < ActiveRecord::Migration
  def change
    execute(<<-SQL)
      CREATE OR REPLACE FUNCTION array_sort (ANYARRAY)
      RETURNS ANYARRAY LANGUAGE SQL
      AS $$
      SELECT ARRAY(
          SELECT $1[s.i] AS "elem"
          FROM
              generate_series(array_lower($1,1), array_upper($1,1)) AS s(i)
          ORDER BY elem
      );
      $$;
    SQL
  end
end
