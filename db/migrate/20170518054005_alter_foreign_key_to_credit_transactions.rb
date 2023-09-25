class AlterForeignKeyToCreditTransactions < ActiveRecord::Migration
  def up
    remove_foreign_key :credit_transactions, :users
    add_foreign_key :credit_transactions, :users, on_delete: :cascade
    remove_foreign_key :credit_transactions, :beneficiary_user
    add_foreign_key :credit_transactions, :users, column: :beneficiary_user_id, on_delete: :cascade
  end

  def down
    remove_foreign_key :credit_transactions, :users
    add_foreign_key :credit_transactions, :users
    remove_foreign_key :credit_transactions, :beneficiary_user
    add_foreign_key :credit_transactions, :users, column: :beneficiary_user_id
  end
end
