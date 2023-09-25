require "rails_helper"

describe Transaction do
  let(:transaction) { create(:transaction) }
  let(:another_transaction) { create(:transaction) }

  describe ".reject" do
    let(:user) { create(:user) }
    let(:reason) { "test reason" }

    before do
      transaction.reject(user, reason)
    end

    context "when transaction is rejected" do
      it "should return rejected_by and reason" do
        expect(transaction.rejected_by).to eq(user.id)
        expect(transaction.rejection_reason).to eq(reason)
      end
    end

    context "when transaction is not yet rejected" do
      it "should not return rejected_by and reason" do
        expect(another_transaction.rejected_by).to be_nil
        expect(another_transaction.rejection_reason).to be_nil
      end
    end
  end

  describe ".add_attachments" do
    let(:attachment) { File.new(Rails.root.join("spec", "files", "response.png").to_s) }

    context "when attachment is added" do
      it "should return attachment" do
        expect { transaction.add_attachments([attachment]) }.to change { transaction.attachments.count }.by(1)
      end
    end
  end

  describe ".remove_attachments" do
    let!(:document) { create(:attachment, transaction_image: transaction) }

    context "when attachment is removed" do
      it "should delete attachment" do
        expect { transaction.remove_attachment(document.id) }.to change {
          transaction.attachments.reload.count
        }.from(1).to(0)
      end
    end
  end

  describe ".approve_transaction" do
    let(:user) { create(:user) }

    before do
      transaction.approve_transaction(user)
    end

    context "when transaction is approved" do
      it "it should return user" do
        expect(transaction.approved_at).to be_present
        expect(transaction.approved_by).to eq(user.id)
      end
    end

    context "when transaction is not approved" do
      it "it should not return user" do
        expect(another_transaction.approved_at).to be_nil
        expect(another_transaction.approved_by).to be_nil
      end
    end
  end

  describe ".verified" do
    let(:user) { create(:user) }

    context "when approved_by or rejected_by present " do
      it "should return approved_by or rejected_by" do
        transaction.approve_transaction(user)
        expect(transaction.verified?).to be_truthy
      end
    end

    context "when approved_by or rejected_by is not present " do
      it "should not return approved_by or rejected_by" do
        expect(transaction.verified?).to be_falsey
      end
    end
  end

  describe "accessible?" do
    let(:user) { create(:user) }

    context "when user is equal to current_user" do
      it "should be accessible" do
        expect(transaction.accessible?(transaction.user)).to be_truthy
      end
    end

    context "when user is not equal to current_user" do
      it "should not be accessible" do
        expect(transaction.accessible?(user)).to be_falsey
      end
    end
  end

  describe ".approved?" do
    let(:user) { create(:user) }

    context "when approved by is present" do
      it "should be approved" do
        transaction.approve_transaction(user)
        expect(transaction.approved?).to be_truthy
      end
    end

    context "when approved by is not present" do
      it "should not  be approved" do
        expect(transaction.approved?).to be_falsey
      end
    end
  end

  describe ".reject?" do
    let(:user) { create(:user) }
    let(:reason) { "test reason" }

    context "when reject by is present" do
      it "should be rejected" do
        transaction.reject(user, reason)
        expect(transaction.rejected?).to be_truthy
      end
    end

    context "when rejected by is not present" do
      it "should not  be rejected" do
        expect(transaction.rejected?).to be_falsey
      end
    end
  end

  describe ".total_transaction_amount" do
    let(:user) { create(:user) }
    let!(:transaction) { create(:transaction, amount: 10, approved_by: user.id) }
    let!(:another_transaction) { create(:transaction, amount: 10, rejected_by: user.id) }
    let!(:yet_another_transaction) { create(:transaction, amount: 10) }

    it "should return total non rejected transaction amount" do
      expect(Transaction.total_transaction_amount).to eq(20)
    end
  end

  describe ".previous_transactions" do
    let(:user) { create(:user) }
    let!(:transaction) do
      create(:transaction, amount: 10, approved_by: user.id, date: Time.zone.today - 1.month)
    end
    let!(:another_transaction) do
      create(:transaction, amount: 10, rejected_by: user.id, date: Time.zone.today - 1.month)
    end
    let!(:yet_another_transaction) do
      create(:transaction, amount: 10, approved_by: user.id, date: Time.zone.today)
    end

    it "should return previous transactions amount before a month" do
      expect(Transaction.previous_transactions(Time.zone.today).sum(:amount)).to eq(10)
    end
  end

  describe ".filter_by_status" do
    let(:user) { create(:user) }
    let!(:approved_transaction) { create(:transaction, approved_by: user.id) }
    let!(:rejected_transaction) { create(:transaction, rejected_by: user.id) }
    let!(:pending_transaction) { create(:transaction) }

    context "when status is present" do
      it "should return all approved transaction " do
        expect(Transaction.filter_by_status(:approved)).to include(approved_transaction)
      end

      it "should return all rejected_transaction" do
        expect(Transaction.filter_by_status(:rejected)).to include(rejected_transaction)
      end

      it "should return all pending_transaction" do
        expect(Transaction.filter_by_status(:pending)).to include(pending_transaction)
      end
    end
  end
end
