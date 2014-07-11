class CardSearch::Parser
  attr_reader :search_string

  COLOR_LOOKUP = {
    'w' => 'White',
    'u' => 'Blue',
    'b' => 'Black',
    'r' => 'Red',
    'g' => 'Green',
  }.freeze

  def initialize(search_string)
    @search_string = search_string
  end

  def scope
    scope = Card.all

    lexer = CardSearch::Lexer.new
    terms = lexer.lex(search_string)

    terms.each do |term|
      case term
      when /\Ae:([a-z0-9,+]+)(\/[a-z]{1,2})?\z/i # Edition code
        scope = edition_query(scope, $1)

      when /c(!|:)([wubrgmlc]+)/i # color
        comparitor = $1
        values = $2.downcase

        scope = color(scope, comparitor, values)

      when /\At:"([^"]+)"\z/i
        type = $1
        scope = card_type_query(scope, type)

      when /\At:(.+)\z/i
        type = $1
        scope = card_type_query(scope, type)

      when /\A!(.+)\z/
        scope = exact_name_query(scope, $1)
      when /\A"([^"]+)"\z/
        scope = name_query(scope, $1)
      else
        scope = name_query(scope, term)
      end
    end

    scope
  end

  private

  def card_type_query(scope, types)
    scope.where("array_sort(LOWER(card_types || supertypes || subtypes))::text[] @> array_sort(ARRAY[?])", types.split(' '))
  end

  def edition_query(scope, codes)
    scope = scope.group("cards.id")

    codes.split("+").each_with_index do |code, i|
      scope = scope.joins("INNER JOIN `editions` AS e#{i} ON e#{i}.`id` = `cards`.`editions_id`")

      if code.include?(',')
        scope = scope.joins(sanitize_sql_array("INNER JOIN `mtg_sets` AS s#{i} ON s#{i}.`id` = e#{i}.`mtg_set_id` AND s#{i}.code IN (?)",
                                               code.split(',').map(&:upcase)))
      else
        scope = scope.joins(sanitize_sql_array("INNER JOIN `mtg_sets` AS s#{i} ON s#{i}.`id` = e#{i}.`mtg_set_id` AND s#{i}.code = ?",
                                               code.upcase))
      end
    end

    Rails.logger.warn scope.to_sql

    scope
  end

  def exact_name_query(scope, name)
    if name =~ /^AE/
      name.sub!(/^AE/, 'A')
    end
    scope = scope.where("unaccent(cards.name) = ?", name)
  end

  def name_query(scope, name)
    if name =~ /^AE/
      name.sub!(/^AE/, 'A')
    end
    scope = scope.where("unaccent(cards.name) ILIKE ?", "%#{name}%")
  end

  def color(scope, comparitor, values)
    colors = letters_to_colors(letters(values))

    if values == "m"
      scope.where("array_length(colors, 1) > 1")
    elsif comparitor == ':'
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
    elsif comparitor == '!'
      queries = []

      queries << sanitize_sql_array("array_sort(colors)::text[] = array_sort(ARRAY[?])", colors)

      if values.length > 1 && !values.include?('m')
        colors.each do |color|
          queries << "'#{color}' = ALL(colors)"
        end
      end

      scope.where(queries.join(" OR "))
    else
      scope
    end
  end

  def letters(values)
    values.each_char.select {|l| l =~ /[wubrg]/}
  end

  def letters_to_colors(letters)
    letters.map {|l| COLOR_LOOKUP.fetch(l)}
  end

  def sanitize_sql_array(*args)
    Card.send(:sanitize_sql_array, args)
  end
end
