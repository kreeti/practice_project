class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :name
      t.string :email, null: false
      t.string :google_oauth_token

      t.timestamps null: false
    end
  end
end
