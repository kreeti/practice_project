class AddColumnAdminToUser < ActiveRecord::Migration
  def up
    add_column :users, :admin, :boolean, default: false
  end

  def down
    remove_column :user, :admin, :boolean, default: false
  end
end
