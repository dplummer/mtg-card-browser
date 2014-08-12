class PostgresSearchBackend
  class AnyColor
    def self.visit(scope, node)
      values = node.contents
      colors = letters_to_colors(letters(values))

      queries = []

      colors.each do |color|
        queries << "'#{color}' = ANY(colors)"
      end

      if values.include?('c')
        queries << "colors IS NULL"
      end

      if values.include?('l')
        queries << "'Land' = ANY(card_types)"
      end

      if values.include?('m')
        scope = scope.where("array_length(colors, 1) > 1")
      end

      scope.where(queries.join(" OR "))
    end

    def self.letters(values)
      values.each_char.select {|l| l =~ /[wubrg]/}
    end

    def self.letters_to_colors(letters)
      letters.map {|l| CardSearch::COLOR_LOOKUP.fetch(l)}
    end
  end
end
