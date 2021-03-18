Rails.application.routes.draw do
  devise_for :users

  resources :attachments, only: %i[ destroy ]

  resources :questions do
    resources :answers, shallow: true do
      member do
        patch :choose_best
      end
    end
  end

  root to: 'questions#index'
end
