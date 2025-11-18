Rails.application.routes.draw do
  # Set the root path to the posts index
  root "posts#index"

  # RESTful routes for posts
  resources :posts

  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check
end
