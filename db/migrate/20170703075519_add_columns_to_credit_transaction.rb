class AddColumnsToCreditTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :credit_transactions, :approved_by_id, :bigint
    add_foreign_key :credit_transactions, :users, column: :approved_by_id

    add_column :credit_transactions, :rejected_by_id, :bigint
    add_foreign_key :credit_transactions, :users, column: :rejected_by_id

    add_column :credit_transactions, :approved_at, :datetime
    add_column :credit_transactions, :rejected_at, :datetime
    add_column :credit_transactions, :rejection_reason, :string
  end
end
