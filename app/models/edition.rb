class Edition < ActiveRecord::Base
  belongs_to :mtg_set
  belongs_to :card
  has_many :printings
  has_one :printing
end
