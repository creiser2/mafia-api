class AddAliveToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :alive, :boolean
  end
end
