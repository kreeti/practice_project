class CreateVendors < ActiveRecord::Migration[7.0]
  def change
    create_table :vendors do |t|
      t.string :name, null: false
      t.string :street
      t.string :street2
      t.string :city
      t.string :state
      t.string :country
      t.string :gst_no
      t.string :pan_no

      t.timestamps
    end
  end
end
