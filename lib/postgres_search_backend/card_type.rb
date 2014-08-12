class PostgresSearchBackend
  class CardType
    def self.visit(scope, node)
      types = node.contents.split(' ')

      scope.where("array_sort(LOWER(card_types || supertypes || subtypes))::text[] @> array_sort(ARRAY[?])", types)
    end
  end
end
