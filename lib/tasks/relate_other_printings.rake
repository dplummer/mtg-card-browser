desc "Relate split and double faced cards"
task :relate_other_printings do
  Card.where("names IS NOT NULL").find_each do |card|
    card.editions.find_each do |edition|
      printings = edition.printings.to_a

      printings.each do |printing|
        other = printings.detect {|p| p != printing} ||
          Printing.joins(:edition => :card).
            where(editions: {mtg_set_id: edition.mtg_set_id}).
            where(cards: {name: card.names - [card.name]}).
            first

        if other.nil?
          binding.pry
        end
        printing.other_printing_id = other.id
        printing.save!
      end
    end
  end
end
