class LobbiesChannel < ApplicationCable::Channel

  def subscribed
    #find created lobby passed from lobby controller and stream for that particular lobby
    @lobby = Lobby.find(params[:lobby_id])
    stream_for @lobby
    # self.connection.connection_identifier =
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
