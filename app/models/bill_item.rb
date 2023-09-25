class BillItem < ApplicationRecord
  belongs_to :bill

  validates :amount, presence: true, numericality: { greater_than: 0 }
end
