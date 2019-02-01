Rails.application.routes.draw do
  resources :questions, only: %i[index new]
end
