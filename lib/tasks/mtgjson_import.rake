namespace :mtgjson do
  task :import, [:filename] => :environment do |t, args|
    if args[:filename].blank?
      warn "You must specify a filename"
      exit(1)
    end
    require 'progress'

    j = JSON.parse(File.read(args[:filename]))
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
