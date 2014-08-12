class PostgresSearchBackend
  class RulesText
    def self.visit(scope, node)
      text = node.contents

      scope.where("text ILIKE ?", "%#{text}%")
    end
  end
end
