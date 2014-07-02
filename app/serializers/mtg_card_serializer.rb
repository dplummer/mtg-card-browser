class MtgCardSerializer < ActiveModel::Serializer
  include MtgSetIconHelper

  attributes :number, :name, :type_text, :mana_cost, :rarity, :artist,
    :image_url, :previous_card, :next_card, :set, :printings, :editions,
    :text, :cmc, :flavor, :multiverse_id, :printing_id, :other_part, :cc_id

  has_many :rulings

  def printing_id
    object.printing.id
  end

  def other_part
    if object.other_part
      {
        name: object.other_part.name,
        number: object.other_part.number
      }
    end
  end

  def previous_card
    if object.previous_card
      {
        name: object.previous_card.name,
        number: object.previous_card.number
      }
    end
  end

  def next_card
    if object.next_card
      {
        name: object.next_card.name,
        number: object.next_card.number
      }
    end
  end

  def set
    {
      code: object.set.code,
      name: object.set.name
    }
  end

  def printings
    object.printings.map do |printing|
      {
        current_printing: printing == object,
        number: printing.number,
        artist: printing.artist
      }
    end
  end

  def editions
    object.editions.map do |edition|
      {
        current_edition: edition == object,
        number: edition.number,
        rarity: edition.rarity,
        set: {
          code: edition.set.code,
          name: edition.set.name,
          icon: icon_url(edition.set.icon_by_rarity(edition.rarity.downcase))
        }
      }
    end
  end
end
