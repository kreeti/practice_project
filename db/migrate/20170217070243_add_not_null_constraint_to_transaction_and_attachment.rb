class AddNotNullConstraintToTransactionAndAttachment < ActiveRecord::Migration
  def change
    change_column :attachments, :transaction_id, :integer, null: false
    change_column :transactions, :user_id, :integer, null: false
  end
end
