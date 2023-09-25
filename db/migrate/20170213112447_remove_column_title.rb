class RemoveColumnTitle < ActiveRecord::Migration
  def change
    remove_column :transactions, :title
  end
end
