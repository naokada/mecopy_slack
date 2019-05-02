Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  devise_for :users
  resources :users, only: [:edit, :update]
  resources :channels do
    collection do
      get :search_user
      get :search
    end
    member do
      # post 'channels/participate/:channel_id', to: :participate
      # delete 'channels/participate/:channel_etunid', to: :unparticipate
      post :participate
      delete :unparticipate
    end
  end
  resources :directs, only: [:new, :create, :show]
  root 'channels#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
