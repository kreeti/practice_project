class RemoveColumnTitle < ActiveRecord::Migration[7.0]
  def change
    remove_column :transactions, :title
  end
end
