# Clear existing rooms
Room.destroy_all

# Create rooms
rooms_data = [
  { name: "Deluxe Suite", price_per_night: 200, booked: false },
  { name: "Ocean View Room", price_per_night: 150, booked: false },
  { name: "Family Room", price_per_night: 180, booked: false },
  { name: "Standard Room", price_per_night: 100, booked: false },
  { name: "Executive Suite", price_per_night: 250, booked: false },
  { name: "Garden View Room", price_per_night: 130, booked: false }
]

rooms_data.each do |room_attrs|
  Room.create!(room_attrs)
end

puts "Created #{Room.count} rooms"