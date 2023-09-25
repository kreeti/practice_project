FactoryBot.define do
  factory :bill do
    ref_no 6715
    date Date.current

    before :create do |bill|
      bill.bill_items << build(:bill_item, product: "paper", amount: 2000, bill_id: bill.id)
    end
  end
end
