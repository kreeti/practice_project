class AddAttachmentImageToAttachments < ActiveRecord::Migration[7.0]
  def self.up
    change_table :attachments do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :attachments, :image
  end
end
