class PostgresSearchBackend
  class OrGroup
    def self.visit(scope, node)
      inner_scope = node.tokens.inject(scope) do |scope, node|
        klass = node.class.name.demodulize
        PostgresSearchBackend.const_get(klass).visit(scope, node)
      end

      scope.where(inner_scope.where_values.join(' OR '))
    end
  end
end
