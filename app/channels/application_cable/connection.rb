module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
  end

  def connect
    byebug
    self.current_user = find_verified_user
  end

  private

  def find_verified_user
    byebug
  end
end
