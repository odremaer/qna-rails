Rails.application.routes.draw do
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
    resources :answers, concerns: %i[ votable ], shallow: true do
      member do
        patch :choose_best
      end
    end
  end

  root to: 'questions#index'
end
