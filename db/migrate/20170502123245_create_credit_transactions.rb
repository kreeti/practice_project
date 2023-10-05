class CreateCreditTransactions < ActiveRecord::Migration[7.0]
  def up
    create_table :credit_transactions do |t|
      t.integer     :amount,  null: false
      t.belongs_to  :user, foreign_key: true, null: false, on_delete: :cascade
      t.bigint     :beneficiary_user_id, null: false
      t.foreign_key :users, column: :beneficiary_user_id, on_delete: :cascade

      t.timestamps
    end

    add_index :credit_transactions, :beneficiary_user_id
  end

  def down
    drop_table :credit_transactions
  end
end
