class Api::BookingsController < ActionController::API
  before_action :authenticate_user!

  def index
    bookings = current_user.bookings.includes(:room)
  
    render json: bookings.as_json(
      only: [:id, :start_date, :end_date, :created_at, :updated_at],
      include: {
        room: {
          only: [:id, :name]
        }
      }
    )
  end

  def create
    room = Room.find(params[:room_id])
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])
  
    # Check for overlapping bookings
    if room.bookings.where("start_date < ? AND end_date > ?", end_date, start_date).exists?
      render json: { error: "Someone else beat you to that day, try another room" }, status: 400
    else
      booking = room.bookings.new(start_date: start_date, end_date: end_date, user: @current_user)
  
      if booking.save
        render json: {
          message: "Room successfully booked!",
          booking: booking.as_json(
            only: [:id, :start_date, :end_date],
            include: {
              room: {
                only: [:id, :name]
              }
            }
          )
        }, status: 201
      else
        render json: { error: "Failed to create booking" }, status: 500
      end
    end
  end
  
  def destroy    
    @booking = current_user.bookings.find(params[:id])  
    
    if @booking.destroy
      render json: { message: 'Booking deleted successfully' }, status: :ok
    else
      render json: { error: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Booking not found: #{e.message}"
    render json: { error: 'Booking not found or unauthorized' }, status: :not_found
  end

  private

  def authenticate_user!
    token = request.headers["Authorization"]&.split("Bearer ")&.last

    if token.nil?
      render json: { error: "Authorization token missing" }, status: :unauthorized
      return
    end

    begin
      decoded_token = JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })
      user_id = decoded_token.first["user_id"]
      @current_user = User.find(user_id) 

    rescue JWT::DecodeError => e
      render json: { error: "Invalid token" }, status: :unauthorized
    end
  end
  

  # Accessor for the current_user
  def current_user
    @current_user
  end
end
