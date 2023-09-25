require "rails_helper"

RSpec.describe Bill, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  let!(:vendor1) do
    create(:vendor, street: "jniouguf", street2: "mnvdjf", city: "12, uvrnez",
                    state: "jniouguf", country: "jniouguf", gst_no: "35415", pan_no: "24682")
  end
  let!(:bill2) do
    create(:bill, total_cgst: 3241, total_sgst: 9452, total_igst: 2468, total_amount: 6240,
                  vendor_id: vendor1.id)
  end

  context "object creation" do
    it "should save successfully" do
      expect(bill2.valid?).to eq(true)
    end
  end

  context "Reference number validation" do
    before do
      bill2.update(ref_no: nil)
    end

    it "ensures reference number presence" do
      expect(bill2.valid?).to eq(false)
    end
  end

  context "Date validation" do
    before do
      bill2.update(date: nil)
    end

    it "ensures date presence" do
      expect(bill2.valid?).to eq(false)
    end
  end

  context "Vendor id validation" do
    before do
      bill2.update(vendor_id: nil)
    end

    it "ensures vendor id presence" do
      expect(bill2.valid?).to eq(false)
    end
  end

  context "Bill Item validation" do
    it "ensures bill item presence" do
      expect(bill2.bill_items.first.valid?).to eq(true)
    end
  end

  describe "#to_csv" do
    it "should create header for csv" do
      expect(Bill.csv_header.collect(&:humanize))
        .to eq ["Id", "Vendor", "Ref no", "Date", "Total cgst", "Total sgst", "Total igst", "Total amount"]
    end
  end
end
