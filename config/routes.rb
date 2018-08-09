Rails.application.routes.draw do
  resources :lobbies, only: [:index, :create]
  post '/available' => 'lobbies#checkAvail'
  mount ActionCable.server => '/cable'
end
