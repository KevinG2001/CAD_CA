RSpec.describe Room, type: :model do
  # Test for associations
  
  # Testing if a room has many bookings and if dependent: :destroy works
  describe "associations" do
    it "has many bookings" do
      association = described_class.reflect_on_association(:bookings)
      expect(association.macro).to eq(:has_many)  # This test should pass as a Room should have many Bookings
    end

    it "destroys associated bookings when the room is destroyed" do
      room = Room.create!(name: "Room 101", price_per_night: 100, booked: false)
      user = User.create!(email: "user@example.com", first_name: "John", last_name: "Doe", password: "password123", password_confirmation: "password123")
      
      # Create a booking associated with the room
      booking = Booking.create!(room: room, user: user, start_date: "2024-12-25", end_date: "2024-12-30")
      
      expect { room.destroy }.to change { Booking.count }.by(-1)  # This test should pass as the booking should be deleted when the room is destroyed
    end
  end

  # Test for valid attributes
  it "is valid with a name, price_per_night, and booked status" do
    room = Room.new(name: "Room 101", price_per_night: 100, booked: false)
    expect(room).to be_valid  # This test should pass because all required attributes are provided
  end

  # Test for invalid room without a name
  it "is invalid without a name" do
    room = Room.new(price_per_night: 100, booked: false)
    expect(room).to_not be_valid  # This test should fail because the name is missing
  end

  # Test for invalid room without a price_per_night
  it "is invalid without a price_per_night" do
    room = Room.new(name: "Room 101", booked: false)
    expect(room).to_not be_valid  # This test should fail because the price_per_night is missing
  end
end
