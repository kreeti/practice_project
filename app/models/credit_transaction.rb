class CreditTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :beneficiary_user, class_name: "User", foreign_key: "beneficiary_user_id"
  belongs_to :approved_by, class_name: "User", foreign_key: "approved_by_id"
  belongs_to :rejected_by, class_name: "User", foreign_key: "rejected_by_id"

  validates :amount, presence: true, numericality: true
  validates :transaction_on, :beneficiary_user_id, presence: true

  scope :between,                            ->(date_range) { where(transaction_on: date_range) }
  scope :order_credit_transactions_in_group, -> { order(transaction_on: :desc, updated_at: :desc) }
  scope :non_rejected_credit_transactions,   -> { where(rejected_by_id: nil) }
  scope :previous_credit_transactions,       lambda { |date|
                                               non_rejected_credit_transactions.where("transaction_on < ?", date)
                                             }

  def reject(user, reason)
    touch(:rejected_at)
    update(rejected_by_id: user.id, rejection_reason: reason)
  end

  def approve_transaction(user)
    touch(:approved_at)
    update_attribute(:approved_by_id, user.id)
  end

  def verified?
    approved_by_id.present? || rejected_by_id.present?
  end

  def self.total_credit_transaction_amount
    non_rejected_credit_transactions.sum(:amount)
  end
end
