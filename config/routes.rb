require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper

  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root 'reviews#index'

  devise_for :users,
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             },
             controllers: { omniauth_callbacks: 'oauth_callbacks' }

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
      resources :reviews, only: %i[ show update ]
    end
  end


  namespace :dashboard do
    resources :users, only: [:index] do
      collection do
        patch :change_type
      end
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
