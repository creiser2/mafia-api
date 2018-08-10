class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.alive = true
    @user.role = "townsfolk"
    @lobby = Lobby.find(user_params[:lobby_id])

    #return json to the user of himself
    if @user.save
      render json: @user
      #broadcast to all subs the new user that has jo
      LobbiesChannel.broadcast_to(@lobby, {lobby: @lobby, users: @lobby.users})
    end
  end

  def update
  end

  private

  def user_params
    params.require(:user).permit(:username, :lobby_id)
  end
end
