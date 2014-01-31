class MtgSet < ActiveRecord::Base
  has_many :mtg_cards

  def self.import_from_mtgjson(set_json)
    mtg_set = find_or_initialize_by(name: set_json['name'])
    mtg_set.code         = set_json['code']
    mtg_set.release_date = set_json['releaseDate']
    mtg_set.border       = set_json['border']
    mtg_set.release_type = set_json['type']
    mtg_set.block        = set_json['block']
    mtg_set.save!
    mtg_set
  end
end
