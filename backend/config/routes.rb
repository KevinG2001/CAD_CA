Rails.application.routes.draw do
  namespace :api do
    resources :rooms, only: [:index] do
      member do
        post :check_availability
      end
    end

    resources :bookings, only: [:create]
  end
end
