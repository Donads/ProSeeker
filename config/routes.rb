Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'

  resources :projects, only: %i[index new create show edit update] do
    resources :project_proposals, only: %i[index update new create show] # shallow nesting breaks form_with on project show page
    post 'close', on: :member
    post 'finish', on: :member
    get 'my_projects', on: :collection
  end

  resources :project_proposals, only: %i[edit update destroy] do
    post 'approve', on: :member
    get 'cancel', on: :member
    get 'rate', on: :member
    get 'reject', on: :member
  end

  resources :professional_profiles, only: %i[new create edit update show]

  resources :feedbacks, only: %i[new create show] do
    get 'received/:user_id', on: :collection, to: 'feedbacks#feedbacks_received', as: :received
  end

  resources :knowledge_fields, only: %i[index new create]

  scope '/admin' do
    get 'manage_records', to: 'admin#manage_records'
  end
end
