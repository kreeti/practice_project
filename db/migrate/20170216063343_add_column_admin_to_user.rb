class AddColumnAdminToUser < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :admin, :boolean, default: false
  end

  def down
    remove_column :user, :admin, :boolean, default: false
  end
end
