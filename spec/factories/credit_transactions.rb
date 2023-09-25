FactoryBot.define do
  factory :credit_transaction do
    user { create(:user) }
    beneficiary_user { create(:user) }
    transaction_on Time.zone.today
    amount 1
  end
end
