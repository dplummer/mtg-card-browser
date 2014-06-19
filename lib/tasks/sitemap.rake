namespace :sitemap do
  task :export => :environment do
    puts "http://mtgbrowser.com"
    MtgSet.find_each do |set|
      puts "http://mtgbrowser.com/#{set.code}/en"
      Printing.joins(:edition).where(editions: {mtg_set_id: set.id}).
        where("number IS NOT NULL AND number > 0").pluck(:number).each do |number|
          puts "http://mtgbrowser.com/#{set.code}/en/#{number}"
      end
    end
  end
end
