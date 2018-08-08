class LobbySerializer < ActiveModel::Serializer
  attributes :id, :name, :password
  has_many :users
end
