class PostgresSearchBackend
  class Edition
    def self.visit(scope, node)
      codes = node.contents
      scope = scope.group("cards.id")

      codes.split("+").each_with_index do |code, i|
        scope = scope.joins(%Q{INNER JOIN "editions" AS e#{i} ON e#{i}."card_id" = "cards"."id"})

        if code.include?(',')
          scope = scope.joins(sanitize_sql_array(%Q{INNER JOIN "mtg_sets" AS s#{i} ON s#{i}."id" = e#{i}."mtg_set_id" AND s#{i}.code IN (?)},
                                                code.split(',').map(&:upcase)))
        else
          scope = scope.joins(sanitize_sql_array(%Q{INNER JOIN "mtg_sets" AS s#{i} ON s#{i}."id" = e#{i}."mtg_set_id" AND s#{i}.code = ?},
                                                code.upcase))
        end
      end

      scope
    end

    def self.sanitize_sql_array(*args)
      Card.send(:sanitize_sql_array, args)
    end
  end
end
