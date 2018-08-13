Rails.application.routes.draw do
  resources :lobbies, only: [:index, :create, :destroy, :show]
  resources :users, only: [:create, :update, :destroy]
  post '/available' => 'lobbies#checkAvail'
  post '/joinlobby' => 'lobbies#joinLobby'
  post '/startgame' => 'lobbies#startGame'
  mount ActionCable.server => '/cable'
end
