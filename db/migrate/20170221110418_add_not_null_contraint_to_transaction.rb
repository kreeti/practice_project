class AddNotNullContraintToTransaction < ActiveRecord::Migration
  def change
     change_column :transactions, :account_id, :integer, null: false
  end
end
