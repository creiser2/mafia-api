module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
  end

  def connect
    self.current_user = User.find(params[:user_id])
  end

  private

  def find_verified_user
    byebug
  end
end
