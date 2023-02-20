Rails.application.routes.draw do

  root 'reviews#index'

  resources :reviews, only: %i[new create show index]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
