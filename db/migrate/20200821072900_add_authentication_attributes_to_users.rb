class AddAuthenticationAttributesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :otp_secret_key, :string,                 after: :email
    add_column :users, :qr_option,      :boolean, default: true, after: :otp_secret_key

    User.find_each { |user| user.update(otp_secret_key: User.otp_random_secret) }
  end
end
