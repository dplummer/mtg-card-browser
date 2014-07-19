module WarpMetrics
  class MarketPrice
    attr_reader :avg, :stdev, :min, :max, :median, :high, :low
    def initialize(hash)
      @avg    = hash['avg'].to_f
      @stdev  = hash['stdev'].to_f
      @min    = hash['min'].to_f
      @max    = hash['max'].to_f
      @median = hash['median'].to_f
      @high   = hash['high'].to_f
      @low    = [hash['low'].to_f, 0.0].max # HACK until metrics can be patched
    end
  end
end
