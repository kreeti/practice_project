class Attachment < ApplicationRecord
  belongs_to :transaction_image, foreign_key: "transaction_id", class_name: "Transaction"

  has_attached_file :document
  validates_attachment :document,
                       content_type: { content_type: ["image/jpg", "image/jpeg", "image/png",
                                                      "image/gif", "application/pdf"] }
end
