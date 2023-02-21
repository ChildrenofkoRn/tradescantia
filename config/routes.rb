Rails.application.routes.draw do

  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' }

  root 'reviews#index'

  resources :reviews, only: %i[new create show index]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
