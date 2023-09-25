require "rails_helper"

RSpec.describe Vendor, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  let!(:vendor1) do
    create(:vendor, street: "jniouguf", street2: "mnvdjf", city: "12, uvrnez",
                    state: "jniouguf", country: "jniouguf", gst_no: "35415", pan_no: "24682")
  end

  context "object creation" do
    it "should save successfully" do
      expect(vendor1.valid?).to eq(true)
    end
  end

  context "name validation" do
    before do
      vendor1.update(name: nil)
    end

    it "ensures name presence" do
      expect(vendor1.valid?).to eq(false)
    end
  end
end
