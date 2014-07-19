module CcImport
  class HttpLookup
    attr_reader :printing

    def initialize(printing)
      @printing = printing
    end

    def category_name
      category_name_lookup(printing.edition.mtg_set.name)
    end

    def card_name
      printing.edition.card.name
    end

    def run
      raw = perform_search
      results = JSON.parse(raw)

      if results["products"].length == 1
        printing.cc_id = results["products"][0]["id"]
        printing.save
      else
        binding.pry
      end
    end

    def perform_search
      query = {
        search: {
          category_name_eq: category_name,
          name_eq: card_name
        }
      }
      RestClient.get("https://catalog.crystalcommerce.com/api/v1/products?#{query.to_query}")
    end

    def category_name_lookup(set_name)
      CcImport::SET_LOOKUP.invert.fetch(set_name, set_name)
    end
  end
end
