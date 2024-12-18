class Booking < ApplicationRecord
  belongs_to :room

  validates :start_date, :end_date, presence: true
  validate :check_room_availability

  private

  def check_room_availability
    # Check if the room is already booked for the same dates
    overlapping_bookings = Booking.where(room_id: room_id)
                                  .where.not(id: id)  # Exclude the current booking if updating
                                  .where("start_date <= ? AND end_date >= ?", end_date, start_date)
    
    if overlapping_bookings.exists?
      errors.add(:base, "Someone else beat you to that day, try another room")
    end
  end
end
