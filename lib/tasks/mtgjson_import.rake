namespace :mtgjson do
  task :import, [:filename] => :environment do |t, args|
    if args[:filename].blank?
      warn "You must specify a filename"
      exit(1)
    end
    require 'progress'

    j = JSON.parse(File.read(args[:filename]))
    if j.key?('cards')
      count = j['cards'].length
      Progress.start("Importing #{count} cards", count) do
        import_set(j)
      end
    else
      count = j.map {|_, set| set['cards'].length}.sum
      Progress.start("Importing #{count} cards", count) do
        j.each do |_, set_json|
          import_set(set_json)
        end
      end
    end
  end

  def import_set(set_json)
    set = Import::Set.from_mtgjson(set_json.except('cards'))
    set_json['cards'].each do |card|
      Import::Card.from_mtgjson(set, card)
      Progress.step
    end
  end
end
