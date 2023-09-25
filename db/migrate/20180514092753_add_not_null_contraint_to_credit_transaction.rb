class AddNotNullContraintToCreditTransaction < ActiveRecord::Migration[5.0]
  def change
    change_column_null :credit_transactions, :transaction_on, false
  end
end
