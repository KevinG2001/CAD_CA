module Api
  class RoomsController < ActionController::API
    def index
      @rooms = Room.all
      render json: @rooms
    end

    def check_availability
      room = Room.find(params[:id])
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])

      # Check for overlapping bookings
      if room.bookings.where("start_date < ? AND end_date > ?", end_date, start_date).exists?
        render json: { error: "Someone else beat you to that day, try another room" }, status: 400
      else
        render json: { message: "Room available for booking" }, status: 200
      end
    end

    
  end
end
