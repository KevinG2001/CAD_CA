require 'rails_helper'

RSpec.describe 'Api::RoomsController', type: :request do
  # Create a user with is_admin attribute
  let!(:admin) { User.create!(email: 'admin@example.com', password: 'password123', first_name: 'Admin', last_name: 'User', is_admin: true) }
  let!(:user) { User.create!(email: 'user@example.com', password: 'password123', first_name: 'John', last_name: 'Doe') }
  let!(:room) { Room.create!(name: 'Room 101', price_per_night: 100.0) }

  let(:valid_room_params) do
    {
      room: { name: 'Room 102' }
    }
  end

  let(:invalid_room_params) do
    {
      room: { name: '' }
    }
  end

  describe 'GET /api/rooms' do
    context 'when rooms exist' do
      before do
        get '/api/rooms'
      end

      it 'returns all rooms' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Room 101') # Adjust the room name as needed
      end
    end
  end

  describe 'POST /api/rooms/:id/check_availability' do
    let!(:room) { Room.create!(name: 'Room 101', price_per_night: 100.0) }

    context 'when room is available' do
      before do
        post "/api/rooms/#{room.id}/check_availability", params: { start_date: '2024-12-20', end_date: '2024-12-22' }
      end

      it 'returns room available message' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Room available for booking')
      end
    end

    context 'when room is not available due to overlapping booking' do
      before do
        room.bookings.create!(start_date: '2024-12-19', end_date: '2024-12-21', user: user)
        post "/api/rooms/#{room.id}/check_availability", params: { start_date: '2024-12-20', end_date: '2024-12-22' }
      end

      it 'returns error for overlapping booking' do
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to include('Someone else beat you to that day, try another room')
      end
    end
  end


end
