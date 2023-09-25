class Transaction < ApplicationRecord
  BEGINNING_MONTH_OF_FINANCIAL_YEAR = 4

  belongs_to :account
  belongs_to :user
  belongs_to :user_approved_by, class_name: "User", foreign_key: "approved_by"
  belongs_to :user_rejected_by, class_name: "User", foreign_key: "rejected_by"

  has_many :attachments, dependent: :destroy

  validates :date, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 999_999.99 }
  validates :account, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true

  scope :between,                     ->(date_range) { where(date: date_range) }
  scope :pending_transactions,        -> { where(approved_by: nil, rejected_by: nil) }
  scope :approved_transactions,       -> { where.not(approved_by: nil) }
  scope :rejected_transactions,       -> { where.not(rejected_by: nil) }
  scope :order_transactions_in_group, -> { order(date: :desc, updated_at: :desc) }
  scope :non_rejected_transactions,   -> { where(rejected_by: nil) }
  scope :previous_transactions,       ->(date) { non_rejected_transactions.where("date < ?", date) }

  STATUS = { approved: "approved_transactions", pending: "pending_transactions",
             rejected: "rejected_transactions" }.freeze
  YEARLY = "Yearly".freeze
  MONTHLY = "Monthly".freeze
  QUARTERLY = "Quarterly".freeze
  TIME_INTERVAL = [MONTHLY, QUARTERLY, YEARLY].freeze

  def reject(user, reason)
    touch(:rejected_at)
    update(rejected_by: user.id, rejection_reason: reason)
  end

  def add_attachments(attachments)
    attachments.each do |attachment|
      self.attachments.create(document: attachment)
    end
  end

  def remove_attachment(document)
    attachments.find(document).destroy unless approved?
  end

  def approve_transaction(user)
    touch(:approved_at)
    update_attribute(:approved_by, user.id)
  end

  def verified?
    approved_by.present? || rejected_by.present?
  end

  def accessible?(current_user)
    user == current_user
  end

  def approved?
    approved_by.present?
  end

  def rejected?
    rejected_by.present?
  end

  def self.total_transaction_amount
    non_rejected_transactions.sum(:amount)
  end

  def self.filter_by_status(status)
    if STATUS.key?(status.to_sym)
      send(STATUS[status.to_sym])
    else
      all
    end
  end
end
