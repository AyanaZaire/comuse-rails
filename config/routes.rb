Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :registrations, only: [:new, :create]
  resources :sessions, only: [:new, :create]

  delete "/signout", to: "sessions#destroy"

  resources :users, only: [:show]

end
