require "rails_helper"

describe CreditTransaction do
  describe ".previous_credit_transactions" do
    let(:user) { create(:user) }
    let!(:credit_transaction) do
      create(:credit_transaction, amount: 10, beneficiary_user: user, transaction_on: Time.zone.today - 1.month)
    end
    let!(:another_credit_transaction) do
      create(:credit_transaction, amount: 10, transaction_on: Time.zone.today - 1.month)
    end
    let!(:yet_another_credit_transaction) do
      create(:credit_transaction, amount: 10, beneficiary_user: user, transaction_on: Time.zone.today)
    end

    it "should return previous credit transactions amount before a month" do
      expect(CreditTransaction.previous_credit_transactions(Time.zone.today).sum(:amount)).to eq(20)
    end
  end
end
