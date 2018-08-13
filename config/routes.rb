Rails.application.routes.draw do
  resources :lobbies, only: [:index, :create, :destroy]
  resources :users, only: [:create, :update, :destroy]
  post '/available' => 'lobbies#checkAvail'
  post '/joinlobby' => 'lobbies#joinLobby'
  mount ActionCable.server => '/cable'
end
