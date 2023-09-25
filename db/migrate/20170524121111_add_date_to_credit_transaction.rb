class AddDateToCreditTransaction < ActiveRecord::Migration
  def change
    add_column :credit_transactions, :transaction_on, :date
  end
end
