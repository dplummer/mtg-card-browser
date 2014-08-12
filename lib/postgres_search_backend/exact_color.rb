class PostgresSearchBackend
  class ExactColor
    def self.visit(scope, node)
      values = node.contents
      colors = letters_to_colors(letters(values))

      queries = []

      queries << sanitize_sql_array("array_sort(colors)::text[] = array_sort(ARRAY[?])", colors)

      if values.length > 1 && !values.include?('m')
        colors.each do |color|
          queries << "'#{color}' = ALL(colors)"
        end
      end

      scope.where(queries.join(" OR "))
    end

    def self.letters(values)
      values.each_char.select {|l| l =~ /[wubrg]/}
    end

    def self.letters_to_colors(letters)
      letters.map {|l| CardSearch::COLOR_LOOKUP.fetch(l)}
    end

    def self.sanitize_sql_array(*args)
      Card.send(:sanitize_sql_array, args)
    end
  end
end
