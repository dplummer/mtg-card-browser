module Import
  class Card
    def self.from_mtgjson(set, card_json)
      card = find_or_create_card(card_json)

      ::Import::Edition.from_mtgjson(set, card,
        card_json.slice('multiverseid', 'imageName', 'flavor', 'artist',
                        'border', 'watermark', 'rarity', 'number',
                        'variations'))

      ::Import::Ruling.from_mtgjson(card, card_json.fetch('rulings', []))

      card
    end

    def self.find_or_create_card(card_json)
      ::Card.find_or_create_by!(name: card_json['name']) do |card|
        card.names                  = card_json['names']
        card.mana_cost              = card_json['manaCost']
        card.cmc                    = card_json['cmc']
        card.colors                 = card_json['colors']
        card.type_text              = card_json['type']
        card.supertypes             = card_json['supertypes']
        card.card_types             = card_json['types']
        card.subtypes               = card_json['subtypes']
        card.text                   = card_json['text']
        card.power                  = card_json['power']
        card.toughness              = card_json['toughness']
        card.layout                 = card_json['layout']
        card.vanguard_hand_modifier = card_json['hand']
        card.vanguard_life_modifier = card_json['life']
        card.foreign_names          = card_json['foreign_names']
      end
    end
  end
end
