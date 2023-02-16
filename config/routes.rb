Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Auth Routes
  match '/users/sign_in' => 'sessions#create', as: :user_sign_in, via: :post
  match '/users/sign_up' => 'users#create', as: :user_sign_up, via: :post

  # Defines the root path route ("/")
  # root "articles#index"
end
