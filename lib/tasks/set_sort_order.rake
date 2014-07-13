require 'progress'

module ResetSortOrder
  def self.reset_sort_order(mtg_set)
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

desc "Resets the sort order for cards"
task :set_sort_order, [:setcode] => :environment do |t, args|
  setcode = args[:setcode]

  if setcode.present?
    mtg_set = MtgSet.find_by_code!(setcode)

    count = Printing.joins(:edition).where(editions: {mtg_set_id: mtg_set.id}).count
    Progress.start("Updating order for #{count} cards", count) do
      ResetSortOrder.reset_sort_order(mtg_set)
    end
  else
    count = Printing.count
    Progress.start("Updating order for #{count} cards", count) do
      MtgSet.find_each do |mtg_set|
        ResetSortOrder.reset_sort_order(mtg_set)
      end
    end
  end
end
