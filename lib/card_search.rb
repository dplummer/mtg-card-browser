class CardSearch
  attr_reader :query

  def initialize(query)
    @query = query
  end

  COLOR_LOOKUP = {
    'w' => 'White',
    'u' => 'Blue',
    'b' => 'Black',
    'r' => 'Red',
    'g' => 'Green',
  }.freeze

  def cards

    cards = scope.
      order("name ASC").
      limit(25)

    MtgCard.decorate_cards(cards)
  end

  def all_color_equality(values)
    colors = values.each_char.to_a - ['m']
    colors = colors.map{|letter| COLOR_LOOKUP.fetch(letter)}
    return "array_sort(colors)::text[] = array_sort(ARRAY[?])", colors
  end

  def scope
    scope = Card.all

    query.split(' ').each do |part|
      case part
      when /t:([a-z-]+)/i
        type = $1
        scope = scope.where("? = ANY(LOWER(card_types)) OR ? = ANY(LOWER( subtypes ))", type, type)
      when /e:([a-z0-9])/i # Edition code
        value = $1 
        scope = scope.joins(:editions => :mtg_set).
          where(mtg_sets: {code: value.upcase})

      when /c(!|:)([wubrgmlc]+)/i # color
        comparitor = $1
        values = $2.downcase

        scope = color(scope, comparitor, values)
      else
        if part =~ /^AE/
          part.sub!(/^AE/, 'A')
        end
        scope = scope.where("unaccent(cards.name) ILIKE ?", "%#{part}%")
      end
    end

    Rails.logger.warn scope.to_sql

    scope
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
