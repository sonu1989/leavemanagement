class Circular < ApplicationRecord
  validates_presence_of :note, :published_at
  validates_length_of :note, :maximum => 200

  scope :find_circular,-> {where(published: true).last}
end
