class Account < ApplicationRecord
  has_many :transactions, dependent: :destroy
  has_many :pending_transactions,  -> { where(approved_by: nil, rejected_by: nil) }, class_name: "Transaction"
  has_many :approved_transactions, -> { where.not(approved_by: nil) }, class_name: "Transaction"
  has_many :rejected_transactions, -> { where.not(rejected_by: nil) }, class_name: "Transaction"

  validates :name, presence: true

  scope :filter_transaction, ->(date_range) { joins(:transactions).merge(Transaction.where(date: date_range)) }
  scope :order_by_name, -> { order(name: :asc) }
  scope :active, -> { where(active: true) }

  def total_transaction_amount(date_range = nil)
    if date_range.present?
      transactions.between(date_range).to_a.sum(&:amount)
    else
      transactions.to_a.sum(&:amount)
    end
  end

  def total_number_of_transactions(date_range = nil)
    if date_range.present?
      transactions.between(date_range).size
    else
      transactions.size
    end
  end

  def total_approved_transaction_amount(date_range = nil)
    if date_range.present?
      approved_transactions.between(date_range).to_a.sum(&:amount)
    else
      approved_transactions.to_a.sum(&:amount)
    end
  end

  def total_pending_transaction_amount(date_range = nil)
    if date_range.present?
      pending_transactions.between(date_range).to_a.sum(&:amount)
    else
      pending_transactions.to_a.sum(&:amount)
    end
  end

  def total_rejected_transaction_amount(date_range = nil)
    if date_range.present?
      rejected_transactions.between(date_range).to_a.sum(&:amount)
    else
      rejected_transactions.to_a.sum(&:amount)
    end
  end

  def destroy
    if transactions.present?
      errors.add(:base, "Account cannot be deleted as it's transaction is present")
      false
    else
      super
    end
  end
end
