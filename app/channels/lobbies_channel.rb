class LobbiesChannel < ApplicationCable::Channel
  def subscribed
    #find created lobby passed from lobby controller and stream for that particular lobby
    @lobby = Lobby.find(params[:lobby_id])

    stream_for @lobby
  end

  def recieved(data)
    @lobby = Lobby.find(params[:lobby_id])
    byebug
    LobbiesChannel.broadcast_to(@lobby, {lobby: @lobby, users: @lobby.waiting_users})
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
