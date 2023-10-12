class Bill < ApplicationRecord
  belongs_to :vendor

  has_attached_file :document
  has_many :bill_items, dependent: :destroy

  validates :ref_no, presence: true
  validates :date, presence: true
  validates :vendor, presence: true
  do_not_validate_attachment_file_type :document
  validates :bill_items, presence: true

  accepts_nested_attributes_for :bill_items, allow_destroy: true, reject_if: ->(item) { item["product"].blank? }

  scope :order_by_date_asc, -> { order(date: :asc) }

  def total_gst_amount(type)
    return unless is_gst?

    case type
    when "cgst"
      bill_items.sum(:cgst)
    when "sgst"
      bill_items.map(&:sgst).sum
    when "igst"
      bill_items.map(&:igst).sum
    else
      0.0
    end
  end

  def self.filter_month_year(search, month, year)
    if month
      search.result.where("extract(month from date) = ? and extract(year from date) = ?", month, year).order(date: :asc)
    else
      search.result.where("extract(year from date) = ?", year).order(date: :asc)
    end
  end

  def self.csv_header
    # Column Header
    %w[
      id
      vendor
      ref_no
      date
      total_cgst
      total_sgst
      total_igst
      total_amount
    ]
  end

  def self.to_csv(collection)
    CSV.generate(col_sep: ";") do |csv|
      csv << Bill.csv_header.collect(&:humanize)
      collection.find_each do |record|
        csv << [
          record.id,
          record.vendor.name,
          record.ref_no,
          record.date,
          record.total_cgst,
          record.total_sgst,
          record.total_igst,
          record.total_amount
        ]
      end
    end
  end
end
