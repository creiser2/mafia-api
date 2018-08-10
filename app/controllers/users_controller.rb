class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.alive = true
    @user.role = "townsfolk"
    if @user.save
      render json: @user
    end
  end

  def update
  end

  private

  def user_params
    params.require(:user).permit(:username, :lobby_id)
  end
end
