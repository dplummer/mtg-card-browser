class PostgresSearchBackend
  class Artist
    def self.visit(scope, node)
      scope.where(artist: node.contents)
    end
  end
end
