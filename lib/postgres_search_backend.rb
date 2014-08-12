class PostgresSearchBackend
  attr_reader :scope

  def initialize(scope)
    @scope = scope
  end

  def visit(parsed)
    @scope = parsed.inject(scope) do |scope, node|
      klass = node.class.name.demodulize
      "::PostgresSearchBackend::#{klass}".constantize.visit(scope, node)
    end
  end
end
