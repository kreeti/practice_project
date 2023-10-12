class ChangeDateColumnFromTransaction < ActiveRecord::Migration[7.0]
  def up
    change_column :transactions, :date, :date, null: false
  end

  def down
    change_column :transactions, :date, :datetime
  end
end
