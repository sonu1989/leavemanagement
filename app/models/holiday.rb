class Holiday < ApplicationRecord
  validates :date, uniqueness: true
end
