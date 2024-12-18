module Api
  class BookingsController < ActionController::API
    def create
      room = Room.find(params[:room_id])  # Get the room based on the ID passed in the params
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])

      # Check for overlapping bookings
      if room.bookings.where("start_date < ? AND end_date > ?", end_date, start_date).exists?
        render json: { error: "Someone else beat you to that day, try another room" }, status: 400
      else
        # Create the booking
        booking = room.bookings.create(start_date: start_date, end_date: end_date)

        if booking.persisted?
          render json: { message: "Room successfully booked!" }, status: 201
        else
          render json: { error: "Failed to create booking" }, status: 500
        end
      end
    end
  end
end
