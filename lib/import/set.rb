module Import
  class Set
    def self.from_mtgjson(json)
      mtg_set = ::MtgSet.find_or_initialize_by(name: json['name'])
      mtg_set.code         = json['code']
      mtg_set.release_date = json['releaseDate']
      mtg_set.border       = json['border']
      mtg_set.release_type = json['type']
      mtg_set.block        = json['block']
      mtg_set.save!
      mtg_set
    end
  end
end
