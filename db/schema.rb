# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_03_29_080021) do
  create_table "accounts", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
  end

  create_table "attachments", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "transaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_file_name"
    t.string "document_content_type"
    t.bigint "document_file_size"
    t.datetime "document_updated_at"
    t.index ["transaction_id"], name: "index_attachments_on_transaction_id"
  end

  create_table "bill_items", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "bill_id", null: false
    t.string "product", null: false
    t.string "hsn_code"
    t.decimal "amount_before_tax", precision: 30, scale: 2, default: "0.0"
    t.decimal "cgst", precision: 30, scale: 2, default: "0.0"
    t.decimal "sgst", precision: 30, scale: 2, default: "0.0"
    t.decimal "igst", precision: 30, scale: 2, default: "0.0"
    t.decimal "amount", precision: 30, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_id"], name: "index_bill_items_on_bill_id"
  end

  create_table "bills", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "vendor_id", null: false
    t.string "ref_no", null: false
    t.date "date", null: false
    t.decimal "total_cgst", precision: 30, scale: 2, default: "0.0"
    t.decimal "total_sgst", precision: 30, scale: 2, default: "0.0"
    t.decimal "total_igst", precision: 30, scale: 2, default: "0.0"
    t.decimal "total_amount", precision: 30, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_file_name"
    t.string "document_content_type"
    t.bigint "document_file_size"
    t.datetime "document_updated_at"
    t.boolean "is_gst", default: false
    t.index ["vendor_id"], name: "index_bills_on_vendor_id"
  end

  create_table "credit_transactions", charset: "utf8mb3", force: :cascade do |t|
    t.integer "amount", null: false
    t.bigint "user_id", null: false
    t.bigint "beneficiary_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "transaction_on", null: false
    t.bigint "approved_by_id"
    t.bigint "rejected_by_id"
    t.datetime "approved_at"
    t.datetime "rejected_at"
    t.string "rejection_reason"
    t.index ["approved_by_id"], name: "fk_rails_609d1d6691"
    t.index ["beneficiary_user_id"], name: "index_credit_transactions_on_beneficiary_user_id"
    t.index ["rejected_by_id"], name: "fk_rails_f5336fd0bc"
    t.index ["user_id"], name: "index_credit_transactions_on_user_id"
  end

  create_table "transactions", charset: "utf8mb3", force: :cascade do |t|
    t.date "date", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.text "description"
    t.integer "approved_by"
    t.datetime "approved_at"
    t.integer "rejected_by"
    t.datetime "rejected_at"
    t.string "rejection_reason"
    t.bigint "account_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "uid"
    t.string "name"
    t.string "email", null: false
    t.string "otp_secret_key"
    t.boolean "qr_option", default: true
    t.string "google_oauth_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.boolean "is_active", default: true
  end

  create_table "vendors", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "street"
    t.string "street2"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "gst_no"
    t.string "pan_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "attachments", "transactions"
  add_foreign_key "bill_items", "bills"
  add_foreign_key "bills", "vendors"
  add_foreign_key "credit_transactions", "users"
  add_foreign_key "credit_transactions", "users", column: "approved_by_id"
  add_foreign_key "credit_transactions", "users", column: "beneficiary_user_id", on_delete: :cascade
  add_foreign_key "credit_transactions", "users", column: "rejected_by_id"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "users"
end
