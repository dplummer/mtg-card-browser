class CardSearch
  attr_reader :query

  def initialize(query)
    @query = query
  end

  def cards
    scope = Card

    query.split(' ').each do |part|
      if part.index(':')
        key, value = part.split(':')
        case key
        when 'e'
          scope = scope.joins(:editions => :mtg_set).
            where(mtg_sets: {code: value.upcase})
        end
      else
        if part =~ /^AE/
          part.sub!(/^AE/, 'A')
        end
        scope = scope.where("unaccent(cards.name) ILIKE ?", "%#{part}%")
      end
    end

    cards = scope.
      order("name ASC").
      limit(25)

    MtgCard.decorate_cards(cards)
  end
end
