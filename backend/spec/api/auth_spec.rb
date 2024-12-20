require 'rails_helper'

RSpec.describe 'AuthController', type: :request do
  describe 'POST /api/auth/signup' do
    let(:valid_attributes) do
      {
        auth: {
          email: 'user@example.com',
          password: 'password123',
          first_name: 'John',
          last_name: 'Doe'
        }
      }
    end

    let(:invalid_attributes) do
      {
        auth: {
          email: 'user@example.com',
          password: '',
          first_name: '',
          last_name: ''
        }
      }
    end

    context 'when valid parameters are provided' do
      it 'creates a new user and returns a token' do
        post '/api/auth/signup', params: valid_attributes

        expect(response).to have_http_status(:created)
        expect(response.body).to include('Account created successfully')
        expect(response.body).to include('token')
      end
    end

    context 'when invalid parameters are provided' do
      it 'does not create a user and returns errors' do
        post '/api/auth/signup', params: invalid_attributes

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Password can't be blank")
        expect(response.body).to include("First name can't be blank")
        expect(response.body).to include("Last name can't be blank")
      end
    end
  end

  
end
