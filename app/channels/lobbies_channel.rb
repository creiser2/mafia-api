class LobbiesChannel < ApplicationCable::Channel

  def subscribed
    #find created lobby passed from lobby controller and stream for that particular lobby
    @lobby = Lobby.find(params[:lobby_id])
    stream_for @lobby
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    @user = User.find(params[:user_id]).destroy
    @lobby = Lobby.find(params[:lobby_id])
    @users = @lobby.users
    LobbiesChannel.broadcast_to(@lobby, {type: "DC_USER", user: @user, updated_users: @users})
  end
end
