FactoryBot.define do
  factory :transaction do
    date  Time.zone.today
    account { create(:account) }
    amount 1
    user { create(:user) }
  end
end
