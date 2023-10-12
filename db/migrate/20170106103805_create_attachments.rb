class CreateAttachments < ActiveRecord::Migration[7.0]
  def change
    create_table :attachments do |t|
      t.references :transaction, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
