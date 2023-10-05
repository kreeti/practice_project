class RemoveImageFromAttachment < ActiveRecord::Migration[7.0]
  def self.up
    remove_attachment :attachments, :image
  end

  def self.down
    add_attachment :attachments, :image
  end
end
