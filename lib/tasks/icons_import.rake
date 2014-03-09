namespace :icons do
  task :import => :environment do
    require 'progress'

    mapping = {
      "Sixth Edition Classic" => "Classic Sixth Edition",
      "Judgement" => "Judgment",
      "Masters Edition I" => "Masters Edition"
    }

    Dir[Rails.root.join('public', 'images', 'icons', '*.svg')].with_progress.each do |filename|
      filename = File.basename(filename)
      _, name, rarity = filename[0..-5].split(" - ")

      if name =~ / vs /
        name = name.gsub(/ vs /, " vs. ")
      elsif mapping.key?(name)
        name = mapping[name]
      elsif filename =~ /Timeshifted/
        name = 'Time Spiral "Timeshifted"'
      elsif name =~ /From the Vault /
        name = name.gsub(/From the Vault /, "From the Vault: ")
      elsif name =~ /Premium Deck Series /
        name = name.gsub(/Premium Deck Series /, "Premium Deck Series: ")
      end

      set = MtgSet.find_by_name_like(name)

      if set && !MtgSetIcon.where(filename: filename).exists?
        MtgSetIcon.create({
          mtg_set: set,
          filename: filename,
          rarity: rarity && rarity.downcase
        })
      end
    end
  end
end
