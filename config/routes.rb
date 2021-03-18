Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    member do
      delete :delete_image_attachment
    end
    resources :answers, shallow: true do
      member do
        patch :choose_best
        delete :delete_image_attachment
      end
    end
  end

  root to: 'questions#index'
end
