class CreateBills < ActiveRecord::Migration[7.0]
  def change
    create_table :bills do |t|
      t.references :vendor, index: true, foreign_key: true, null: false
      t.integer :ref_no, null: false
      t.date :date, null: false
      t.integer :total_cgst
      t.integer :total_sgst
      t.integer :total_igst
      t.integer :total_amount

      t.timestamps
    end
  end
end
