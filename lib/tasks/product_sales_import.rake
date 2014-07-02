desc "Import product sales"
task :product_sales_import, [:filename] => :environment do |t, args|
  filename = args[:filename]
  raise "must define filename" unless filename
  lines = `wc -l #{filename}`.chomp.to_i - 1

  cc_ids = Printing.pluck(:cc_id).to_set

  columns = [:cc_id, :sell_price_cents, :date]

  points = []

  Progress.start("reading #{lines} product sales", lines) do
    CSV.foreach(filename, headers: true) do |row|
      cc_id = row['catalog_id'].to_i

      if cc_ids.include?(cc_id)
        sell_price_cents = (row['sell_price'].to_f * 100).to_i
        row['qty'].to_i.times do
          points << [cc_id, sell_price_cents, row['date']]
        end
      end

      if points.length > 1000
        ProductSalePoint.import columns, points, validate: false
        points = []
      end

      Progress.step
    end
  end

  ProductSalePoint.import columns, points, validate: false

  puts "There are now #{ProductSalePoint.count} sale points"
end
