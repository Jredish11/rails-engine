Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index]
    end
  end
  namespace :api do
    namespace :v1 do
      resources :items, only: [:index]
    end
  end
  
  # Defines the root path route ("/")
  # root "articles#index"
end
