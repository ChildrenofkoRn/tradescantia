require 'sidekiq/web'

Rails.application.routes.draw do

  use_doorkeeper

  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users,
             path_names: { sign_in: 'login', sign_out: 'logout' },
             controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root 'reviews#index'

  get 'search/index'

  concern :rankable do
    member do
      patch :ranking
    end
  end

  resources :reviews, concerns: %i[ rankable ]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
