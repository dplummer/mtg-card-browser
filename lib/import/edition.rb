module Import
  class Edition
    def self.from_mtgjson(set, card, json)
      edition = ::Edition.find_or_initialize_by(mtg_set_id: set.id, card_id: card.id)
      edition.rarity    = json['rarity']
      edition.flavor    = json['flavor']
      edition.watermark = json['watermark']
      edition.border    = json['border']
      edition.save!

      ::Import::Printing.from_mtgjson(edition,
        json.slice('artist', 'multiverseid', 'imageName', 'number'))

      json.fetch('variations', []).each do |variation_id|
        ::Import::Printing.from_mtgjson(edition, 'multiverseid' => variation_id)
      end

      edition
    end
  end
end
