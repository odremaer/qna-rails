Rails.application.routes.draw do
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
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[ index ] do
        get :me, on: :collection
      end

      resources :questions, only: %i[ index show ] do
        resources :answers, only: %i[ index show ], shallow: true
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
