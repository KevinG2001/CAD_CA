module Api
  class AuthController < ActionController::API
    # POST /api/auth/signup
    # Creates a new user account
    def signup
      user = User.new(user_params) 
      
      if user.save
        token = encode_token(user.id)
        render json: { message: 'Account created successfully', token: token }, status: :created
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # POST /api/auth/login
    # Logs the user in if the credentials are correct
    def login
      user = User.find_by(email: params[:email]) 

      if user && user.authenticate(params[:password]) 
        token = encode_token(user.id, user.is_admin)
        
        render json: { message: 'Login successful', token: token, is_admin: user.is_admin }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end

    private
    # Strong parameter method for securely allowing only the required attributes
    def user_params
      params.require(:auth).permit(:email, :password, :first_name, :last_name)
    end    

    def encode_token(user_id, is_admin = false)
      payload = {
        user_id: user_id, 
        exp: 24.hours.from_now.to_i, 
        is_admin: is_admin   
      }

      JWT.encode(payload, Rails.application.secret_key_base)
    end
  end
end
