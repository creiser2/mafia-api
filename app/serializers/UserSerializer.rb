class LobbySerializer < ActiveModel::Serializer
  attributes :id, :username, :lobby_id, :alive, :role
  belongs_to :lobby
end
