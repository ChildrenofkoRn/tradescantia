require 'sidekiq/web'

Rails.application.routes.draw do

  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users,
             path_names: { sign_in: 'login', sign_out: 'logout' },
             controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root 'reviews#index'

  concern :rankable do
    member do
      patch :ranking
    end
  end

  resources :reviews, concerns: %i[ rankable ]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
