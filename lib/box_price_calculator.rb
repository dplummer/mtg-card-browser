class BoxPriceCalculator
  attr_reader :mtg_set

  def initialize(mtg_set)
    @mtg_set = mtg_set
  end

  DISTRIBUTION = {
    "Uncommon"    => 3,
    "Mythic Rare" => 0.125,
    "Rare"        => 0.875,
    "Common"      => 10
  }
  PACKS_PER_BOX = 36

  def average_market_price
    market_price(:avg)
  end

  def low_market_price
    market_price(:low)
  end

  def market_price(column)
    DISTRIBUTION.map do |rarity, distribution|
      rarity_price(column, rarity) * distribution
    end.sum * PACKS_PER_BOX
  end

  def rarity_price(column, rarity)
    @rarity_prices ||= CcMarketPrice.joins(:printing => :edition).
      where(editions: {mtg_set_id: mtg_set.id}).
      select("editions.rarity, cc_market_prices.#{column}").
      to_a

    prices = @rarity_prices.
      select{|market_price| market_price["rarity"] == rarity}.
      map {|market_price|
      price = market_price[column]
      price < 100 ? 0 : price
    }

    prices.sum.to_f / prices.length / 100
  end
end
