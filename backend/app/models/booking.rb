class Booking < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :start_date, :end_date, presence: true
  validate :validate_no_overlapping_bookings

  private

  def validate_no_overlapping_bookings
    overlapping_bookings = room.bookings.where("start_date < ? AND end_date > ?", end_date, start_date)
    if overlapping_bookings.exists?
      errors.add(:base, "This room is already booked for the selected dates.")
    end
  end
end
