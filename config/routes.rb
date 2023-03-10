Rails.application.routes.draw do

  devise_for :users,
             path_names: { sign_in: 'login', sign_out: 'logout' },
             controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root 'reviews#index'

  resources :reviews, only: %i[new create edit update destroy delete show index]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
