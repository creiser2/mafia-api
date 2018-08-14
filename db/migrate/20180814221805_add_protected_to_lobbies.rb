class AddProtectedToLobbies < ActiveRecord::Migration[5.2]
  def change
    add_column :lobbies, :protected, :boolean
  end
end
