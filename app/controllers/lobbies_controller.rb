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
    serialized_data = ""
    #the second argument here is what is passed via params
    if lobby.save
      serialized_data = ActiveModelSerializers::Adapter::Json.new(LobbySerializer.new(lobby))
    end

    render json: serialized_data
  end

  #Check to see if the lobby name is available amongst all of the lobby names
  def checkAvail
    lobbies = Lobby.all
    lobbyNames = lobbies.map do |lobby|
      lobby.name
    end
    avail = !lobbyNames.include?(params[:name])
    if avail
      render json: {availability: true}
    else
      render json: {availability: false}
    end
  end

  private

  def lobby_params
    params.require(:lobby).permit(:name, :password)
  end
end
