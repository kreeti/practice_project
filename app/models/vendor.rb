class Vendor < ApplicationRecord
  has_many :bills, dependent: :destroy

  validates :name, presence: true
end
