module WarpMetrics
  class Client
    ROOT            = URI.parse("http://warpmetricsserver.crystalcommerce.com")
    OPEN_TIMEOUT    = 2
    READ_TIMEOUT    = 4
    STAT_TIMEOUT    = 8
    FILTER_TIMEOUT  = 25
    MAX_BATCH_SIZE  = 10_000

    DEFAULT_OPTIONS = {
      :root => ROOT,
      :open_timeout => OPEN_TIMEOUT,
      :read_timeout => READ_TIMEOUT,
      :stat_timeout => STAT_TIMEOUT,
      :filter_timeout => FILTER_TIMEOUT,
      :max_batch_size => MAX_BATCH_SIZE
    }

    class MetricsDisabledError < StandardError; end

    class MetricsTimeoutError < StandardError; end

    attr_reader :options

    def initialize(options = {})
      @options = options.reverse_merge(DEFAULT_OPTIONS)
    end

    # Returns a hash of id to stat
    def fetch_market_prices(ids)
      rescue_metrics_down_with({}, stat_timeout) do
        scatter_gather_batch(ids) do |ids_slice|
          raw = JSON.parse(resource['product_stats'].post(:ids => ids_slice))
          # Preserve misses, which are a nil stat
          hashmap(raw) {|stat| stat && MarketPrice.new(stat)}
        end
      end
    end

  private
    DEFAULT_OPTIONS.keys.each do |m|
      define_method(m) { options.fetch(m) }
      private m
    end

    def scatter_gather_batch(batch, identity = {}, merge = :merge!, &block)
      batch.each_slice(max_batch_size) do |slice|
        identity.send(merge, block.call(slice))
      end

      identity
    end

    def hashmap(h, &blk)
      h.merge(h) {|_, v| blk.call(v) }
    end

    def resource
      @resource ||= RestClient::Resource.new(root.to_s)
    end

    def rescue_metrics_down_with(fallback, failsafe_timeout, &blk)
      Timeout.timeout(failsafe_timeout, MetricsTimeoutError) do
        blk.call
      end
    rescue ::RestClientFatalRequestError, MetricsDisabledError, MetricsTimeoutError
      fallback
    end
  end
end
