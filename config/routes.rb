Rails.application.routes.draw do
  resources :lobbies, only: [:index, :create, :update, :destroy, :show]
  resources :users, only: [:create, :update, :destroy]
  post '/available' => 'lobbies#checkAvail'
  post '/joinlobby' => 'lobbies#joinLobby'
  post '/startgame' => 'lobbies#startGame'
  post '/pickmafia' => 'lobbies#pickMafia'
  post '/disconnect' => 'lobbies#disconnect'
  post '/mafia-exists' => 'lobbes#mafiaExists'
  post '/killvictim' => 'lobbies#killVictim'
  post '/castvote' => 'lobbies#castVote'
  post '/get-random-mafia-kill-story' => 'lobbies#getRandomMafiaKillStory'
  mount ActionCable.server => '/cable'
end
