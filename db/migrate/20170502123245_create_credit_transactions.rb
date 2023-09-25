class CreateCreditTransactions < ActiveRecord::Migration
  def up
    create_table :credit_transactions do |t|
      t.integer     :amount,  null: false
      t.belongs_to  :user, foreign_key: true, null: false
      t.integer     :beneficiary_user_id, null: false
      t.foreign_key :users, column: :beneficiary_user_id

      t.timestamps
    end

    add_index :credit_transactions, :beneficiary_user_id
  end

  def down
    drop_table :credit_transactions
  end
end
