class PostgresSearchBackend
  class ExactName
    def self.visit(scope, node)
      name = node.contents

      if name =~ /^AE/
        name.sub!(/^AE/, 'A')
      end

      scope.where("unaccent(cards.name) = ?", name)
    end
  end
end
