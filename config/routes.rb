Rails.application.routes.draw do
  resources :lobbies, only: [:index, :create, :destroy]
  resources :users, only: [:create, :update, :destroy]
  post '/available' => 'lobbies#checkAvail'
  mount ActionCable.server => '/cable'
end
