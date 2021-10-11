Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'

  resources :projects, only: %i[index new create show] do
    resources :project_proposals, only: %i[index create new show] # shallow nesting breaks form_with on project show page
  end
  resources :project_proposals, only: %i[edit update destroy] do
    post 'approve', on: :member
    post 'reject', on: :member
  end
  patch '/projects/:project_id/project_proposals/:id', to: 'project_proposals#update'

  resources :professional_profiles, only: %i[new create show]
end
