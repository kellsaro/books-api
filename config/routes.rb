Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      defaults format: :json do
        resources :categories, only: %i[index show create destroy]
        resources :books, only: %i[index show create update destroy]
        post 'authentications/login', to: 'authentications#create'
        post 'users/register', to: 'users#create'
      end
    end
  end
end
