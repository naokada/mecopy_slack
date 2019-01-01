Rails.application.routes.draw do
  devise_for :users
  mount ActionCable.server => '/cable'
  resources :channels do
    resources :messages, only: [:create]
  end
  root 'channels#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
