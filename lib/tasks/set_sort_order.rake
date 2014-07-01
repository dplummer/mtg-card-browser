require 'progress'

desc "Resets the sort order for cards"
task :set_sort_order do
  count = Printing.count
  Progress.start("Updating order for #{count} cards", count) do
    MtgSet.find_each do |mtg_set|
      Printing.joins(:edition).where(editions: {mtg_set_id: mtg_set.id}).
        update_all("sort_order = sort_order + 1000")
      cards = MtgCard.find_all_for_set(mtg_set)

      cards.each_with_index do |card, index|
        card.printing.sort_order = index + 1
        card.printing.save!
        Progress.step
      end
    end
  end
end
