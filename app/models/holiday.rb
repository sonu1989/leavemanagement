class Holiday < ApplicationRecord
  validates :date, uniqueness: true
  validates_presence_of :date, :occasion
end
