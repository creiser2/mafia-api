Rails.application.routes.draw do
  resources :lobbies, only: [:index, :create]
  mount ActionCable.server => '/cable'
end
