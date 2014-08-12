class CardSearch::Parser
  attr_reader :search_string

  def initialize(search_string)
    @search_string = search_string
  end

  def scope
    parsed = MtgSearchParser.parse(search_string)
    scope = PostgresSearchBackend.new(Card.all).visit(parsed)

    Rails.logger.warn scope.to_sql

    scope
  end
end
