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

  def joinLobby
    lobbies = Lobby.all
    lobby = lobbies.detect do |lobby|
      lobby.name == lobby_params[:name]
    end

    #user has correct name and password for lobby, let them in
    if lobby_params[:password] == lobby.password
      render json: {password_correct: true, lobby: lobby}
    #user does not have correct password
    else
      render json: {password_correct: false}
    end
  end

  def show
    lobby = Lobby.find(params[:id])
    serialized_data = ActiveModelSerializers::Adapter::Json.new(LobbySerializer.new(lobby))

    if lobby
      render json: {data: serialized_data}
    else
      render json: {response: "no lobby data"}
    end
  end

  def startGame
    @lobby = Lobby.find(lobby_params[:id])
    LobbiesChannel.broadcast_to(@lobby, {startGame: true})
  end

  private

  def lobby_params
    params.require(:lobby).permit(:name, :password, :id)
  end
end
