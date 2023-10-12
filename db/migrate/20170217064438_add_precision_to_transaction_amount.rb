class AddPrecisionToTransactionAmount < ActiveRecord::Migration[7.0]
  def change
    change_column :transactions, :amount, :decimal, precision: 8, scale: 2
  end
end
