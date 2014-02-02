module Import
  class Ruling
    def self.from_mtgjson(card, rulings)
      existing_rulings = ::Ruling.where(card_id: card.id)

      ::Ruling.transaction do
        existing_rulings.each do |ruling|
          if !rulings.map{|r| r['text']}.include?(ruling.text)
            ruling.destroy
          end
        end

        rulings.each do |ruling_json|
          if !existing_rulings.map(&:text).include?(ruling_json['text'])
            ::Ruling.create!(ruling_json.merge(card_id: card.id))
          end
        end
      end
    end
  end
end
