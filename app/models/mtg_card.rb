class MtgCard < ActiveRecord::Base
  belongs_to :mtg_set

  def self.import_from_mtgjson(set, card_json)
    card = find_or_initialize_by(name: card_json['name'], mtg_set_id: set.id)
    card.names                    = card_json['names']
    card.mana_cost                = card_json['manaCost']
    card.cmc                      = card_json['cmc']
    card.colors                   = card_json['colors']
    card.type_text                = card_json['type']
    card.supertypes               = card_json['supertypes']
    card.card_types               = card_json['types']
    card.subtypes                 = card_json['subtypes']
    card.rarity                   = card_json['rarity']
    card.text                     = card_json['text']
    card.flavor                   = card_json['flavor']
    card.artist                   = card_json['artist']
    card.card_number              = card_json['number']
    card.power                    = card_json['power']
    card.toughness                = card_json['toughness']
    card.layout                   = card_json['layout']
    card.multiverse_id            = card_json['multiverseid']
    card.multiverse_variation_ids = card_json['variations']
    card.mtgimage_name            = card_json['imageName']
    card.watermark                = card_json['watermark']
    card.border                   = card_json['border']
    card.vanguard_hand_modifier   = card_json['hand']
    card.vanguard_life_modifier   = card_json['life']
    card.save!
    card
  end

  def set_code
    mtg_set.code
  end
end
