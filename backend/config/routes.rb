Rails.application.routes.draw do
  namespace :api do
    get 'rooms', to: 'rooms#index'
  end
end