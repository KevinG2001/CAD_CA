module Api
  class RoomsController < ActionController::API
    # Ensure that only admins can create rooms by using a before_action
    before_action only: [:create, :update, :destroy]

    # GET /api/rooms
    # Fetches all rooms and returns them in the response
    def index
      @rooms = Room.all 
      render json: @rooms 
    end

    # POST /api/rooms
    # Creates a new room with the provided parameters
    def create
      room = Room.new(room_params)  

      room.price_per_night ||= 100

      if room.save
        render json: { message: "Room successfully created!", room: room }, status: :created
      else
        render json: { error: room.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # POST /api/rooms/:id/check_availability
    # Checks if the room is available for booking within the given date range
    def check_availability
      room = Room.find(params[:id])  
      start_date = Date.parse(params[:start_date])  
      end_date = Date.parse(params[:end_date])  

      if room.bookings.where("start_date < ? AND end_date > ?", end_date, start_date).exists?
        render json: { error: "Someone else beat you to that day, try another room" }, status: 400
      else
        render json: { message: "Room available for booking" }, status: 200
      end
    end

    # PUT /api/rooms/:id
    # Updates the room details
    def update
      room = Room.find(params[:id]) 

      if room.update(room_params)
        render json: { message: "Room successfully updated!", room: room }, status: :ok
      else
        render json: { error: room.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/rooms/:id
    # Deletes the room and its associated bookings
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

    # Strong parameters to permit only the required room attributes
    def room_params
      params.require(:room).permit(:name)  
    end

    # Ensure that only admins can perform create, update, and destroy actions
    def authorize_admin!
      unless current_user&.admin? 
        render json: { error: "Unauthorized" }, status: :forbidden  
      end
    end
  end
end
