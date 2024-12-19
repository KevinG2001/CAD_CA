class Room < ApplicationRecord
  has_many :bookings, dependent: :destroy
end
