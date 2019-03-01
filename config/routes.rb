Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true do
      put :best, on: :member
    end
  end
end
