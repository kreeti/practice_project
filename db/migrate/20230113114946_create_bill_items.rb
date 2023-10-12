class CreateBillItems < ActiveRecord::Migration[7.0]
  def change
    create_table :bill_items do |t|
      t.references :bill, null:   false,  foreign_key: true
      t.string  :product, null:   false
      t.string  :hsn_code
      t.integer :amount_before_tax, default: 0
      t.integer :cgst, default: 0
      t.integer :sgst, default: 0
      t.integer :igst, default: 0
      t.integer :amount, null:   false

      t.timestamps
    end
  end
end
