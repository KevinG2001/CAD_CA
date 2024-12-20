RSpec.describe Booking, type: :model do
  # Test for validations
  
  # Testing if a booking is valid with valid attributes (room, user, start_date, end_date)
  it "is valid with valid attributes" do
    room = Room.create!(name: "Room 101", price_per_night: 100, booked: false)
    user = User.create!(email: "user@example.com", first_name: "John", last_name: "Doe", password: "password123", password_confirmation: "password123")
    booking = Booking.new(
      room: room,
      user: user,
      start_date: "2024-12-25",
      end_date: "2024-12-30"
    )
    expect(booking).to be_valid  # This test should pass since all required attributes are provided
  end

  # Testing if a booking is invalid without a start_date
  it "is invalid without a start_date" do
    room = Room.create!(name: "Room 101", price_per_night: 100, booked: false)
    user = User.create!(email: "user@example.com", first_name: "John", last_name: "Doe", password: "password123", password_confirmation: "password123")
    booking = Booking.new(
      room: room,
      user: user,
      end_date: "2024-12-30"
    )
    expect(booking).to_not be_valid  # This test should fail because start_date is missing
  end

  # Testing if a booking is invalid without an end_date
  it "is invalid without an end_date" do
    room = Room.create!(name: "Room 101", price_per_night: 100, booked: false)
    user = User.create!(email: "user@example.com", first_name: "John", last_name: "Doe", password: "password123", password_confirmation: "password123")
    booking = Booking.new(
      room: room,
      user: user,
      start_date: "2024-12-25"
    )
    expect(booking).to_not be_valid  # This test should fail because end_date is missing
  end

  # Testing the custom validation to prevent overlapping bookings for the same room
  describe "#validate_no_overlapping_bookings" do
    it "is invalid if there is an overlapping booking for the same room" do
      room = Room.create!(name: "Room 101", price_per_night: 100, booked: false)
      user1 = User.create!(email: "user1@example.com", first_name: "John", last_name: "Doe", password: "password123", password_confirmation: "password123")
      user2 = User.create!(email: "user2@example.com", first_name: "Jane", last_name: "Doe", password: "password123", password_confirmation: "password123")

      # Create an existing booking that overlaps
      Booking.create!(
        room: room,
        user: user1,
        start_date: "2024-12-20",
        end_date: "2024-12-25"
      )

      # New booking with overlapping dates
      overlapping_booking = Booking.new(
        room: room,
        user: user2,
        start_date: "2024-12-23",  # Overlaps with the existing booking (2024-12-20 to 2024-12-25)
        end_date: "2024-12-28"
      )

      expect(overlapping_booking).to_not be_valid  # This test should fail because the booking dates overlap
      expect(overlapping_booking.errors[:base]).to include("This room is already booked for the selected dates.")
    end

    it "is valid if there are no overlapping bookings for the same room" do
      room = Room.create!(name: "Room 101", price_per_night: 100, booked: false)
      user1 = User.create!(email: "user1@example.com", first_name: "John", last_name: "Doe", password: "password123", password_confirmation: "password123")
      user2 = User.create!(email: "user2@example.com", first_name: "Jane", last_name: "Doe", password: "password123", password_confirmation: "password123")

      # Create an existing booking that does not overlap
      Booking.create!(
        room: room,
        user: user1,
        start_date: "2024-12-01",
        end_date: "2024-12-05"
      )

      # New booking with non-overlapping dates
      non_overlapping_booking = Booking.new(
        room: room,
        user: user2,
        start_date: "2024-12-06",  # No overlap with the first booking
        end_date: "2024-12-10"
      )

      expect(non_overlapping_booking).to be_valid  # This test should pass because the dates do not overlap
    end
  end

  # Test for associations (belongs_to :room and belongs_to :user)
  describe "associations" do
    it "belongs to room" do
      association = described_class.reflect_on_association(:room)
      expect(association.macro).to eq(:belongs_to)  # This test should pass because a booking belongs to a room
    end

    it "belongs to user" do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)  # This test should pass because a booking belongs to a user
    end
  end
end
