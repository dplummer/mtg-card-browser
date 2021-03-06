class MtgSet < ActiveRecord::Base
  has_many :editions
  has_many :mtg_set_icons
  has_many :cards, through: :editions
  has_many :printings, through: :editions

  def self.find_by_name_like(name)
    find_by_name(name) || where("name ILIKE ?", "%#{name}%").first
  end

  def default_icon
    icon_by_rarity('common')
  end

  def icon_by_rarity(rarity)
    mtg_set_icons.detect {|icon| icon.rarity == rarity} ||
      mtg_set_icons.to_a.first
  end
end
