class MtgSetSerializer < ActiveModel::Serializer
  include MtgSetIconHelper

  attributes :id, :code, :name, :release_type, :release_date, :block, :icon,
    :cards

  def cards
    MtgCard.find_all_for_set(object).map do |card|
      {
        image_url: card.image_url,
        number: card.number,
        name: card.name,
        type_text: card.type_text,
        mana_cost: card.mana_cost,
        rarity: card.rarity,
        artist: card.artist
      }
    end
  end

  def icon
    icon_url(object.default_icon)
  end
end
