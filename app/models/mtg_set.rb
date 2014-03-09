class MtgSet < ActiveRecord::Base
  has_many :editions
  has_many :mtg_set_icons

  def self.find_by_name_like(name)
    find_by_name(name) || where("name ILIKE ?", "%#{name}%").first
  end

  def default_icon
    mtg_set_icons.detect {|icon| icon.rarity == 'common'} ||
      mtg_set_icons.to_a.first
  end
end
