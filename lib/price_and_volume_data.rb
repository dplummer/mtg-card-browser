class PriceAndVolumeData
  attr_reader :mtg_card

  def initialize(mtg_card)
    @mtg_card = mtg_card
  end

  class Price
    attr_reader :date, :avg, :min, :max, :volume

    def initialize(row)
      @date = Date.parse(row['date'])
      @avg = row['avg'].to_f.round(2)
      @min = row['min'].to_f.round(2)
      @max = row['max'].to_f.round(2)
      @volume = row['volume'].to_i
    end

    def to_row
      [date.strftime("%Y/%m/%d"), min, avg, max, volume]
    end
  end

  def prices
    return @prices if defined?(@prices)

    query = ProductSalePoint.where(cc_id: mtg_card.cc_id).
      group(:date).
      order("date").
      select("date",
             "count(*) as volume",
             "avg(sell_price_cents) / 100 AS avg",
             "min(sell_price_cents) / 100 AS min",
             "max(sell_price_cents) / 100 AS max").to_sql

    rows = ProductSalePoint.connection.select_all(query)

    @prices = rows.map {|r| Price.new(r)}
  end
end
