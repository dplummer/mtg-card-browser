class Card < ActiveRecord::Base
  has_many :editions
  has_one :edition
  has_many :rulings
end
