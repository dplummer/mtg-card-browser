class SetSortOrderForPrintings < ActiveRecord::Migration
  def up
    MtgSet.find_each do |mtg_set|
      cards = MtgCard.find_all_for_set(mtg_set)
      cards.each_with_index do |card, index|
        card.printing.sort_order = index + 1
        card.printing.save!
      end
    end
  end
end
