class PostgresSearchBackend
  def self.visit(scope, parsed)
    @scope = parsed.inject(scope) do |scope, node|
      klass = node.class.name.demodulize
      PostgresSearchBackend.const_get(klass).visit(scope, node)
    end
  end
end
