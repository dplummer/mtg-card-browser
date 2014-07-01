task :fix_numbers do
  set_ids = Printing.joins(:edition => :mtg_set).
    where(number: nil).
    group("mtg_sets.id").
    pluck("mtg_sets.id")

  MtgSet.find(set_ids).each do |mtg_set|
    MtgCard.find_all_for_set(mtg_set).each_with_index do |card, index|
      card.printing.update_attributes(number: index + 1)
    end

    puts "Fixed card numbers for #{mtg_set.name}"
  end
end
