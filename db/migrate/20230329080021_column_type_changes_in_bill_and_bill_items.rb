class ColumnTypeChangesInBillAndBillItems < ActiveRecord::Migration[7.0]
  def up
    change_table :bills do |t|
      t.change :ref_no, :string, null: false
      t.change :total_cgst, :decimal, default: 0.0, precision: 30,  scale: 2
      t.change :total_sgst, :decimal, default: 0.0, precision: 30,  scale: 2
      t.change :total_igst, :decimal, default: 0.0, precision: 30,  scale: 2
      t.change :total_amount, :decimal, default: 0.0, precision: 30,  scale: 2
    end

    change_table :bill_items do |t|
      t.change :amount_before_tax, :decimal, default: 0.0, precision: 30,  scale: 2
      t.change :cgst, :decimal, default: 0.0, precision: 30,  scale: 2
      t.change :sgst, :decimal, default: 0.0, precision: 30,  scale: 2
      t.change :igst, :decimal, default: 0.0, precision: 30,  scale: 2
      t.change :amount, :decimal, null: false, precision: 30,  scale: 2
    end
  end
  def down
    change_table :bills do |t|
      t.change :ref_no, :integer, null: false
      t.change :total_cgst, :integer
      t.change :total_sgst, :integer
      t.change :total_igst, :integer
      t.change :total_amount, :integer
    end

    change_table :bill_items do |t|
      t.change :amount_before_tax, :integer, default: 0
      t.change :cgst, :integer, default: 0
      t.change :sgst, :integer, default: 0
      t.change :igst, :integer, default: 0
      t.change :amount, :integer, null: false
    end
  end
end
