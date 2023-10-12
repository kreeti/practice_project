class AddDateToCreditTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :credit_transactions, :transaction_on, :date
  end
end
