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
    scope = Card

    query.split(' ').each do |part|
      case part
      when /e:([a-z0-9])/i # Edition code
        value = $1 
        scope = scope.joins(:editions => :mtg_set).
          where(mtg_sets: {code: value.upcase})

      when /c(!|:)([wubrgml]+)/i # color
        comparitor = $1
        values = $2
        queries = []

        values.each_char do |letter|
          case letter
          when /[wubrg]/
            queries << "'#{COLOR_LOOKUP.fetch(letter)}' = ANY(colors)"
          when 'm'
            scope = scope.where("array_length(colors, 1) > 1")
          when 'l'
            queries << "'Land' = ANY(card_types)"
          end
        end

        if comparitor == ':'
          scope = scope.where(queries.join(" OR "))
        elsif comparitor == '!'
          scope = scope.where(queries.join(" AND "))
        end
      else
        if part =~ /^AE/
          part.sub!(/^AE/, 'A')
        end
        scope = scope.where("unaccent(cards.name) ILIKE ?", "%#{part}%")
      end
    end

    Rails.logger.warn scope.to_sql

    cards = scope.
      order("name ASC").
      limit(25)

    MtgCard.decorate_cards(cards)
  end
end
