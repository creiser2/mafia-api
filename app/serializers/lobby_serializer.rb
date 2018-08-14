class LobbySerializer < ActiveModel::Serializer
  attributes :id, :name, :password, :protected
  has_many :users
end
