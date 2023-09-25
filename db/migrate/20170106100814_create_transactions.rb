class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :title
      t.datetime :date, null: false
      t.decimal :amount, null: false
      t.text :description
      t.integer :user_id
      t.integer :account_id
      t.integer :approved_by
      t.datetime :approved_at
      t.integer :rejected_by
      t.datetime :rejected_at
      t.string :rejection_reason

      t.references :account, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
