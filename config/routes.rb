Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :projects, only: %i[index new create show]
end
