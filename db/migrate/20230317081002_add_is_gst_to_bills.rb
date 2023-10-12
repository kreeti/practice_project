class AddIsGstToBills < ActiveRecord::Migration[7.0]
  def change
    add_column :bills, :is_gst, :boolean, default: false
  end
end
