Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  root to: 'questions#index'

  concern :votable do
    post :upvote, on: :member
    post :downvote, on: :member
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      put :best, on: :member
    end
  end
end
