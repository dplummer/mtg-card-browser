class MtgCard
  def self.find_all_for_set(set)
    set.editions.eager_load({:card => :rulings}, :printings).each_with_object([]) do |edition, acc|
      edition.printings.each do |printing|
        acc << new(set, edition, printing, edition.card)
      end
    end.sort
  end

  def self.find(options = {})
    set = options.fetch(:set) { MtgSet.find_by(code: options[:set_code]) }

    if options[:card_number]
      scope = Printing.where(number: options[:card_number])
    elsif options[:multiverse_id]
      scope = Printing.where(multiverse_id: options[:multiverse_id])
    else
      return
    end

    printing = scope.
      eager_load(:edition => :card).
      where(editions: {mtg_set_id: set.id}).
      first
    new(set, printing.edition, printing, printing.edition.card) if printing
  end

  def self.find_with_multiverse_id(options)
    multiverse_id = options.fetch(:multiverse_id)
    printing = Printing.where(multiverse_id: multiverse_id).
      eager_load(:edition => :card).
      where(editions: {mtg_set_id: set.id}).
      first
    new(set, printing.edition, printing, printing.edition.card) if printing
  end

  def self.decorate_cards(cards)
    cards.includes(:edition => [:mtg_set, :printing]).map do |card|
      edition = card.edition
      new(edition.mtg_set, edition, edition.printing, card)
    end
  end

  attr_reader :set, :edition, :printing, :card

  def initialize(set, edition, printing, card)
    @set = set
    @edition = edition
    @printing = printing
    @card = card
  end

  delegate :name, :code, :to => :set, :prefix => true

  delegate :name, :cmc, :type_text, :text, :rulings, :to => :card

  delegate :flavor, :rarity, :to => :edition

  delegate :multiverse_id, :number, :artist, :mtgimage_name,
    :to => :printing

  def mana_cost
    card.mana_cost.gsub(/\{([WUBRGX0-9])\}/, '\1') if card.mana_cost
  end

  def multiverse_url
    "http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=#{multiverse_id}"
  end

  def image_url
    "http://mtgimage.com/set/#{set_code}/#{mtgimage_name}.jpg" if mtgimage_name
  end

  def ==(b)
    printing.id == b.printing.id
  end

  def <=>(b)
    a = self

    res = (a.number || Float::INFINITY) <=> (b.number || Float::INFINITY)

    if res == 0
      res = a.name <=> b.name
    end

    res
  end

  def set_url
    "/#{set_code}/en"
  end

  def url
    "/#{set_code}/en/#{number}"
  end

  def previous_card
    if number && number > 1
      @previous_card ||= self.class.find(set_code: set_code,
                                         language: "en",
                                         number: number - 1,
                                         set: set)
    end
  end

  def next_card
    if number
      @next_card ||= self.class.find(set_code: set_code,
                                     language: "en",
                                     number: number + 1,
                                     set: set)
    end
  end

  def printings
    edition.printings.map do |other_printing|
      self.class.new(set, edition, other_printing, card)
    end
  end

  def editions
    card.editions.eager_load(:printing, :mtg_set).map do |other_edition|
      self.class.new(other_edition.mtg_set, other_edition, other_edition.printing, card)
    end
  end
end
