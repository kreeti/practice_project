FactoryBot.define do
  factory :bill_item do
    amount { rand(10.2..100.25) }
    bill
  end
end
