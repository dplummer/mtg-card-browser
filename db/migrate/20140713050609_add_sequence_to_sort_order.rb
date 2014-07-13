class AddSequenceToSortOrder < ActiveRecord::Migration
  def change
    execute(<<-SQL)
CREATE SEQUENCE sort_order_seq;
ALTER TABLE printings ALTER sort_order SET DEFAULT NEXTVAL('sort_order_seq');
    SQL
  end
end
