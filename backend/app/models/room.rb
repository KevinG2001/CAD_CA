class Room < ApplicationRecord
  validates :name, presence: true
  has_many :bookings, dependent: :destroy
  validates :price_per_night, presence: true
end
