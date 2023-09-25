require "rails_helper"

RSpec.describe BillItem, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  let!(:vendor1) do
    create(:vendor, street: "jniouguf", street2: "mnvdjf", city: "12, uvrnez",
                    state: "jniouguf", country: "jniouguf", gst_no: "35415", pan_no: "24682")
  end
  let!(:bill1) do
    create(:bill, total_cgst: 3242, total_sgst: 9451, total_igst: 2469, total_amount: 6249,
                  vendor_id: vendor1.id)
  end
  let!(:bill_item2) do
    create(:bill_item, product: "abc xyz", hsn_code: 3214, cgst: 2365,
                       sgst: 1245, igst: 5698, bill_id: bill1.id)
  end

  context "Bill Item creation" do
    it "should save successfully" do
      expect(bill_item2.valid?).to eq(true)
    end

    it "Amount is positive" do
      expect(bill_item2.amount.positive?).to eq(true)
    end
  end

  context "Amount validation" do
    before do
      bill_item2.update(amount: nil)
    end

    it "ensures amount presence" do
      expect(bill_item2.valid?).to eq(false)
    end
  end

  context "Amount positive validation" do
    before do
      bill_item2.update(amount: -100)
    end

    it "Amount should be positive" do
      expect(bill_item2.amount.positive?).to eq(false)
    end
  end
end
