Rails.application.routes.draw do
  namespace :api do
    resources :rooms, only: [:index, :create, :update, :destroy] do
      member do
        post :check_availability
      end
    end

    resources :bookings, only: [:index, :create, :destroy]

    post '/auth/signup', to: 'auth#signup'
    post '/auth/login', to: 'auth#login'
  end
end
