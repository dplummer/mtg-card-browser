namespace :mtgjson do
  task :import => :environment do
    if ENV['file'].blank? || !File.exists?(ENV['file'])
      warn "Specify the filename with file=FILENAME"
      exit
    end

    require 'progress'

    j = JSON.parse(File.read(ENV['file']))
    count = j.map {|_, set| set['cards'].length}.sum
    Progress.start("Importing #{count} cards", count) do
      j.each do |_, set_json|
        set = Import::Set.from_mtgjson(set_json.except('cards'))
        set_json['cards'].each do |card|
          Import::Card.from_mtgjson(set, card)
          Progress.step
        end
      end
    end
  end
end
