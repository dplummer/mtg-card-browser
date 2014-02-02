module Import
  class Printing
    def self.from_mtgjson(edition, json)
      printing = ::Printing.find_or_initialize_by(edition_id: edition.id,
                                                  multiverse_id: json['multiverseid'])
      printing.artist        = json['artist'] unless json['artist'].nil?
      printing.mtgimage_name = json['imageName'] unless json['artist'].nil?
      printing.number        = json['number'] unless json['artist'].nil?
      printing.save!
      printing
    end
  end
end
