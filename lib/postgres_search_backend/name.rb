class PostgresSearchBackend
  class Name
    def self.visit(scope, node)
      name = node.contents

      if name =~ /^AE/
        name.sub!(/^AE/, 'A')
      end

      scope.where("unaccent(cards.name) ILIKE ?", "%#{name}%")
    end
  end
end
