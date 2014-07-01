class MtgCard
  def self.find_all_for_set(set)
    set.editions.eager_load({:card => :rulings}, :printings).each_with_object([]) do |edition, acc|
      edition.printings.each do |printing|
        acc << new(set, edition, printing, edition.card)
      end
    end.sort
  end

  def self.find(sort_order:nil,
                card_number:nil,
                set:nil,
                multiverse_id:nil,
                printing_id:nil,
                set_code:nil)
    set = set || MtgSet.find_by(code: set_code)

    if printing_id
      scope = Printing.where(id: printing_id)
    elsif sort_order
      scope = Printing.where(sort_order: sort_order)
    elsif card_number
      scope = Printing.where(number: card_number)
    elsif multiverse_id
      scope = Printing.where(multiverse_id: multiverse_id)
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
    cards.includes(:rulings, :edition => [{:mtg_set => :mtg_set_icons}, :printing]).map do |card|
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

  delegate :name, :cmc, :colors, :type_text, :text, :rulings, :to => :card

  delegate :flavor, :rarity, :to => :edition

  delegate :multiverse_id, :number, :artist, :mtgimage_name, :sort_order,
    :other_printing_id, :to => :printing

  def mana_cost
    card.mana_cost.gsub(/\{([WUBRGX0-9])\}/, '\1') if card.mana_cost
  end

  def multiverse_url
    "http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=#{multiverse_id}"
  end

  def image_url
    "http://mtgimage.com/set/#{set_code}/#{mtgimage_name}.jpg" if mtgimage_name
  end

  def read_attribute_for_serialization(attr)
    send(attr)
  end

  def ==(b)
    printing.id == b.printing.id
  end

  COLOR_IDENTITY_SORT = [
    :uncolored,
    :white,
    :blue,
    :black,
    :red,
    :green,
    :gold,
    :artifact,
    :land,
    :basic_land
  ]

  def color_identity_index
    @color_identity_index ||= if colors.nil?
      if type_text.start_with?("Basic Last")
        COLOR_IDENTITY_SORT.index(:basic_land)
      elsif type_text.start_with?("Land")
        COLOR_IDENTITY_SORT.index(:land)
      elsif type_text.start_with?("Artifact")
        COLOR_IDENTITY_SORT.index(:artifact)
      else
        COLOR_IDENTITY_SORT.index(:uncolored)
      end
    elsif colors.length == 1
      COLOR_IDENTITY_SORT.index(colors.first.downcase.to_sym)
    elsif colors.length > 1
      COLOR_IDENTITY_SORT.index(:gold)
    end
  end

  def <=>(b)
    a = self

    res = a.number_number <=> b.number_number
    return res if res != 0

    res = a.number <=> b.number
    return res if res != 0

    res = a.color_identity_index <=> b.color_identity_index
    return res if res != 0

    res = a.name <=> b.name

    res
  end

  def set_url
    "/#{set_code}/en"
  end

  def url
    "/#{set_code}/en/#{number}"
  end

  def number_number
    number.nil? ? Float::INFINITY : number.to_i
  end

  def previous_card
    if sort_order > 1
      @previous_card ||= self.class.find(sort_order: sort_order - 1,
                                         set: set)
    end
  end

  def next_card
    return @next_card if defined?(@next_card)
    @next_card = self.class.find(sort_order: sort_order + 1,
                                 set: set)
  end

  def other_part
    if other_printing_id
      @other_part = self.class.find(printing_id: other_printing_id,
                                    set: set)
    end
  end

  def printings
    edition.printings.map do |other_printing|
      self.class.new(set, edition, other_printing, card)
    end
  end

  def editions
    card.editions.eager_load(:printing, :mtg_set).order("mtg_sets.release_date DESC").map do |other_edition|
      self.class.new(other_edition.mtg_set, other_edition, other_edition.printing, card)
    end
  end
end
