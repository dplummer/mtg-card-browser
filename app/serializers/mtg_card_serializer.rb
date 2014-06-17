class MtgCardSerializer < ActiveModel::Serializer
  attributes :number, :name, :type_text, :mana_cost, :rarity, :artist,
    :image_url, :previous_card, :next_card, :set, :printings, :editions,
    :text, :cmc, :flavor

  has_many :rulings

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
          name: edition.set.name
        }
      }
    end
  end
end
