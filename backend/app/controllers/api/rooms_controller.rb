module Api
  class RoomsController < ActionController::API
    before_action only: [:create]

    def index
      @rooms = Room.all
      render json: @rooms
    end

    def create
      room = Room.new(room_params)
  
      if room.save
        render json: { message: "Room successfully created!", room: room }, status: :created
      else
        render json: { error: room.errors.full_messages }, status: :unprocessable_entity
      end
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

    def update
      room = Room.find(params[:id])  

      if room.update(room_params)  
        render json: { message: "Room successfully updated!", room: room }, status: :ok
      else
        render json: { error: room.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      room = Room.find_by(id: params[:id])
    
      if room.nil?
        render json: { error: "Room not found" }, status: :not_found
      else
        room.destroy  
        render json: { message: "Room and associated bookings successfully deleted" }, status: :ok
      end
    end
    
    private

    def room_params
      params.require(:room).permit(:name)
    end

    def authorize_admin!
      unless current_user.admin?
        render json: { error: "Unauthorized" }, status: :forbidden
      end
    end
  end
end
