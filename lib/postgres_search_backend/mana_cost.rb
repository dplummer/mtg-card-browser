class PostgresSearchBackend
  class ManaCost
    def self.visit(scope, node)

      # node.operator
      # node.mana_cost
      case node.operator
      when '='
        cost = node.mana_cost.each_char.map {|l| "{#{l.upcase}}"}.join
        scope.where("mana_cost = ?", cost)
      end
    end
  end
end
