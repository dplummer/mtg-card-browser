require 'progress'

task :load_market_prices => :environment do
  ids = Printing.where("cc_id IS NOT NULL").pluck(:cc_id)
  client = WarpMetrics::Client.new

  Progress.start(ids.count, "Fetching prices for #{ids.length} products") do
    ids.each_slice(100).each do |cc_ids|
      market_prices = client.fetch_market_prices(cc_ids)
      market_prices.each do |id, market_price|
        CcMarketPrice.warp_import(id, market_price)
      end
      Progress.step(cc_ids.length)
    end
  end
end
