# app/controllers/api/rooms_controller.rb
module Api
  class RoomsController < ActionController::API  # Use ActionController::API for API-only controllers

    def index
      @rooms = Room.all
      render json: @rooms, status: :ok
    end
  end
end
