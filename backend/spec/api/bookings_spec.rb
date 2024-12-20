require 'rails_helper'

RSpec.describe 'Api::BookingsController', type: :request do
  let(:user) { User.create!(email: 'user@example.com', password: 'password123', first_name: 'John', last_name: 'Doe') }
  let(:room) { Room.create!(name: 'Room 101', price_per_night: 100.0) }

  let(:valid_booking_params) do
    {
      room_id: room.id,
      start_date: '2024-12-21',
      end_date: '2024-12-23'
    }
  end

  let(:overlapping_booking_params) do
    {
      room_id: room.id,
      start_date: '2024-12-22',
      end_date: '2024-12-24'
    }
  end

  let(:invalid_booking_params) do
    {
      room_id: room.id,
      start_date: 'invalid_date',
      end_date: 'invalid_date'
    }
  end

  before do
    # Create an initial booking for the room
    room.bookings.create!(start_date: '2024-12-20', end_date: '2024-12-22', user: user)
  end

  # Helper method to generate token
  def encode_token(user_id, is_admin = false)
    payload = { user_id: user_id, exp: 24.hours.from_now.to_i, is_admin: is_admin }
    JWT.encode(payload, Rails.application.secret_key_base)
  end

  describe 'GET /api/bookings' do
    context 'when the user is authenticated' do
      before do
        token = encode_token(user.id)
        get '/api/bookings', headers: { 'Authorization': "Bearer #{token}" }
      end

      it 'returns the user\'s bookings' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('start_date')
        expect(response.body).to include('end_date')
        expect(response.body).to include('room')
      end
    end

    context 'when the user is not authenticated' do
      it 'returns an error' do
        get '/api/bookings'
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Authorization token missing')
      end
    end
  end
  
  describe 'DELETE /api/bookings/:id' do
    let!(:booking) { room.bookings.create!(start_date: '2024-12-24', end_date: '2024-12-26', user: user) }

    context 'when the user is authenticated and owns the booking' do
      before do
        token = encode_token(user.id)
        delete "/api/bookings/#{booking.id}", headers: { 'Authorization': "Bearer #{token}" }
      end

      it 'deletes the booking' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Booking deleted successfully')
      end
    end

    context 'when the user is authenticated but does not own the booking' do
      let(:other_user) { User.create!(email: 'other@example.com', password: 'password123', first_name: 'Jane', last_name: 'Doe') }

      before do
        token = encode_token(other_user.id)
        delete "/api/bookings/#{booking.id}", headers: { 'Authorization': "Bearer #{token}" }
      end

      it 'returns an error' do
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Booking not found or unauthorized')
      end
    end

    context 'when the booking does not exist' do
      before do
        token = encode_token(user.id)
        delete "/api/bookings/999999", headers: { 'Authorization': "Bearer #{token}" }
      end

      it 'returns an error' do
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Booking not found or unauthorized')
      end
    end

    context 'when the user is not authenticated' do
      it 'returns an error for missing authentication' do
        delete "/api/bookings/#{booking.id}"
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Authorization token missing')
      end
    end
  end
end
