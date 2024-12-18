module Api
  class AuthController < ActionController::API
    def signup
      user = User.new(user_params)
      if user.save
        token = encode_token(user.id)
        render json: { message: 'Account created successfully', token: token }, status: :created
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def login
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        token = encode_token(user.id)
        render json: { message: 'Login successful', token: token }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end

    private

    def user_params
      params.require(:auth).permit(:email, :password, :first_name, :last_name)
    end    

    def encode_token(user_id)
      JWT.encode({ user_id: user_id, exp: 24.hours.from_now.to_i }, 'your_secret_key')
    end
  end
end
