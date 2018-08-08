class LobbiesController < ApplicationController

  #render a get for all lobbies
  def index
    lobbies = Lobby.all
    serialized_data = lobbies.map { |lobby|
      ActiveModelSerializers::Adapter::Json.new(
      LobbySerializer.new(lobby)
    )}
    render json: serialized_data
  end

  #create a new lobby
  def create
    #broadcasting out with lobby id so that the channel is unique
    lobby = Lobby.new(lobby_params)
    #the second argument here is what is passed via params
    if lobby.save
      ActionCable.server.broadcast("lobbies_#{lobby.id}", lobby: lobby)
    end
  end


  private

  def lobby_params
    params.require(:lobby).permit(:name, :password)
  end
end
