require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users

  resources :attachments, only: %i[ destroy ]
  resources :links, only: %i[ destroy ]
  resources :awards, only: %i[ index ]

  concern :votable do
    member do
      post :upvote
      post :downvote
      delete :undo_vote
    end
  end

  resources :questions, concerns: %i[ votable ] do
    resources :comments, only: :create
    resources :answers, concerns: %i[ votable ], shallow: true do
      resources :comments, only: :create
      member do
        patch :choose_best
      end
    end
    resources :subscriptions, shallow: true, only: %i[ create destroy ]
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[ index ] do
        get :me, on: :collection
      end

      resources :questions, except: %i[ edit new ] do
        resources :answers, except: %i[ edit new ], shallow: true
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
