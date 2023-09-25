require "rails_helper"

describe Account do
  let(:account) { create(:account) }

  describe ".total_transaction_amount" do
    let!(:transaction) { create(:transaction, amount: 10, account: account, date: Time.zone.today) }
    let!(:another_transaction) { create(:transaction, amount: 10, account: account, date: 1.month.ago) }

    context "when user passes date range" do
      it "should return amount within that date range" do
        expect(account.total_transaction_amount(
                 Time.zone.today.beginning_of_month..Time.zone.today.end_of_month
               )).to eq(transaction.amount)
      end
    end

    context "when user doesnot pass a date range" do
      it "should return  sum of all amounts" do
        expect(account.total_transaction_amount).to eq(transaction.amount + another_transaction.amount)
      end
    end
  end

  describe ".total_number_of_transactions" do
    let!(:transaction) { create(:transaction, account: account, date: Time.zone.today) }
    let!(:another_transaction) { create(:transaction, account: account, date: 1.month.ago) }

    context "when user passes date range" do
      it "should return total number of transactions in that date range" do
        expect(account.total_number_of_transactions(
                 Time.zone.today.beginning_of_month..Time.zone.today.end_of_month
               )).to eq(1)
      end
    end

    context "when user doesnot pass date range" do
      it "should return all transactions size " do
        expect(account.total_number_of_transactions).to eq(2)
      end
    end
  end

  describe ".total_approved_transaction_amount" do
    let(:user) { create(:user) }
    let!(:transaction) do
      create(:transaction, account: account, approved_by: user.id,
                           amount: 10, date: Time.zone.today)
    end
    let!(:another_transaction) do
      create(:transaction, account: account,
                           approved_by: user.id, amount: 10, date: 1.month.ago)
    end
    let!(:yet_another_transaction) { create(:transaction, account: account, amount: 10, date: 2.months.ago) }

    context "when user passes date range" do
      it "should return total approved transaction amount within that date_range" do
        expect(account.total_approved_transaction_amount(
                 Time.zone.today.beginning_of_month..Time.zone.today.end_of_month
               )).to eq(10)
      end
    end

    context "when user doesnot pass a date range" do
      it "should return total approved transaction amount" do
        expect(account.total_approved_transaction_amount).to eq(20)
      end
    end
  end

  describe ".total_pending_transaction_amount" do
    let(:user) { create(:user) }
    let!(:transaction) do
      create(:transaction, account: account, amount: 10, approved_by: user.id,
                           rejected_by: user.id, date: Time.zone.today)
    end
    let!(:another_transaction) { create(:transaction, account: account, amount: 10, date: 1.month.ago) }
    let!(:yet_another_transaction) { create(:transaction, account: account, amount: 10, date: Time.zone.today) }

    context "when user passes a date range" do
      it "should return total pending transaction amount within that date_range" do
        expect(account.total_pending_transaction_amount(
                 Time.zone.today.beginning_of_month..Time.zone.today.end_of_month
               )).to eq(10)
      end
    end

    context "when user doesnot pass a date range" do
      it "should return sum of all pending transactions amount" do
        expect(account.total_pending_transaction_amount).to eq(20)
      end
    end
  end

  describe ".total_rejected_transaction_amount" do
    let(:user) { create(:user) }
    let!(:transaction) do
      create(:transaction, account: account, amount: 10,
                           rejected_by: user.id, date: Time.zone.today)
    end
    let!(:another_transaction) { create(:transaction, account: account, amount: 10, date: 1.month.ago) }

    context "when user passes a date range" do
      it "should return total rejected transaction amount within that date range" do
        expect(account.total_rejected_transaction_amount(
                 Time.zone.today.beginning_of_month..Time.zone.today.end_of_month
               )).to eq(10)
      end
    end

    context "when user doesnot pass a date range" do
      it "should return total rejected transaction amount" do
        expect(account.total_rejected_transaction_amount).to eq(10)
      end
    end
  end

  describe ".destroy" do
    let!(:account)         { create(:account) }
    let!(:another_account) { create(:account) }
    let!(:transaction)     { create(:transaction, account: account) }

    context "when transaction is present" do
      it "should not delete account" do
        expect { another_account.destroy }.to change { Account.count }.by(-1)
      end
    end

    context "when transaction is not present" do
      it "should  delete account" do
        expect { account.destroy }.to change { Account.count }.by(0)
      end
    end
  end
end
