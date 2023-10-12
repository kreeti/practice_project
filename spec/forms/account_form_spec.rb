require "rails_helper"

describe AccountForm do
  let(:account)         { create(:account) }
  let(:another_account) { create(:account) }
  let(:user)            { create(:user) }

  describe "#process" do
    context "when previous params and upcoming params are not present" do
      let!(:transaction) { create(:transaction, date: Time.zone.today, account: account) }
      let!(:another_transaction) { create(:transaction, date: 1.month.ago, account: another_account) }
      let(:account_form) { AccountForm.new }

      before do
        account_form.process
      end

      it "should return account within the current month range" do
        expect(account_form.accounts.collect { |acc| acc["account_id"] }).to include(account.id)
      end

      it "should not return account outside the current month range" do
        expect(account_form.accounts.collect { |acc| acc["account_id"] }).not_to include(another_account.id)
      end
    end

    context "when previous params  present" do
      let!(:transaction) { create(:transaction, date: Time.zone.today, account: account) }
      let!(:another_transaction) { create(:transaction, date: 1.month.ago, account: another_account) }
      let(:account_form) do
        AccountForm.new(previous: true, from_date: Time.zone.today.beginning_of_month.to_s,
                        to_date: Time.zone.today.end_of_month.to_s)
      end

      before do
        account_form.process
      end

      it "should return account within the previous month range" do
        expect(account_form.accounts.collect { |acc| acc["account_id"] }).to include(another_account.id)
      end

      it "should not return in the current month range" do
        expect(account_form.accounts.collect { |acc| acc["account_id"] }).not_to include(account.id)
      end
    end

    context "when upcoming params  present" do
      let!(:transaction) { create(:transaction, date: Time.zone.today, account: account) }
      let!(:another_transaction) { create(:transaction, date: Time.zone.today + 1.month, account: another_account) }
      let(:account_form) do
        AccountForm.new(upcoming: true, from_date: Time.zone.today.beginning_of_month.to_s,
                        to_date: Time.zone.today.end_of_month.to_s)
      end

      before do
        account_form.process
      end

      it "should return account within the previous month range" do
        expect(account_form.accounts.collect { |acc| acc["account_id"] }).to include(another_account.id)
      end

      it "should not return in the current month range" do
        expect(account_form.accounts.collect { |acc| acc["account_id"] }).not_to include(account.id)
      end
    end

    context "when account_id params present" do
      let!(:transaction)         { create(:transaction, date: Time.zone.today, account: account) }
      let!(:another_transaction) { create(:transaction, date: 1.month.ago, account: another_account) }
      let(:account_form)         { AccountForm.new(account_id: account.id) }

      before do
        account_form.process
      end

      it "should return account whose account_id is present" do
        expect(account_form.accounts.collect { |acc| acc["account_id"] }).to include(account.id)
      end

      it "should return all accounts" do
        expect(account_form.accounts.collect { |acc| acc["account_id"] }).not_to include(another_account.id)
      end
    end

    describe "#total_number_of_transactions" do
      let!(:transaction) { create(:transaction, date: Time.zone.today, account: account) }
      let!(:another_transaction) { create(:transaction, date: Time.zone.today, account: another_account) }
      let(:account_form) { AccountForm.new }

      before do
        account_form.process
      end

      it "should return total number of transactions in the date range" do
        expect(account_form.total_number_of_transactions).to eq(2)
      end
    end

    describe "#approved_transaction_total_amount" do
      let!(:transaction) do
        create(:transaction, date: Time.zone.today, account: account, approved_by: user.id, amount: 10)
      end
      let!(:another_transaction) do
        create(:transaction, date: Time.zone.today, account: account, approved_by: user.id, amount: 10)
      end
      let!(:yet_another_transaction) do
        create(:transaction, date: Time.zone.today, account: account, amount: 10)
      end
      let(:account_form) { AccountForm.new }

      before do
        account_form.process
      end

      it "should return total approved transactions amount in the date range" do
        expect(account_form.approved_transaction_total_amount).to eq(20)
      end
    end

    describe "#rejected_transaction_total_amount" do
      let!(:transaction) do
        create(:transaction, date: Time.zone.today, account: account, rejected_by: user.id, amount: 10)
      end
      let!(:another_transaction) do
        create(:transaction, date: Time.zone.today, account: account, rejected_by: user.id, amount: 10)
      end
      let!(:yet_another_transaction) do
        create(:transaction, date: Time.zone.today, account: account, amount: 10)
      end
      let(:account_form) do
        AccountForm.new
      end

      before do
        account_form.process
      end

      it "should return total rejected transactions amount in the date range" do
        expect(account_form.rejected_transaction_total_amount).to eq(20)
      end
    end

    describe "#pending_transaction_total_amount" do
      let!(:transaction) do
        create(:transaction, date: Time.zone.today, account: account, rejected_by: user.id, amount: 10)
      end
      let!(:another_transaction) do
        create(:transaction, date: Time.zone.today, account: account, approved_by: user.id, amount: 10)
      end
      let!(:yet_another_transaction) do
        create(:transaction, date: Time.zone.today, account: account, amount: 10)
      end
      let(:account_form) { AccountForm.new }

      before do
        account_form.process
      end

      it "should return total rejected transactions amount in the date range" do
        expect(account_form.rejected_transaction_total_amount).to eq(10)
      end
    end

    describe "#transactions_total_amount" do
      let!(:transaction) do
        create(:transaction, date: Time.zone.today, account: account, rejected_by: user.id, amount: 10)
      end
      let!(:another_transaction) do
        create(:transaction, date: Time.zone.today, account: account, approved_by: user.id, amount: 10)
      end
      let!(:yet_another_transaction) do
        create(:transaction, date: Time.zone.today, account: account, amount: 10)
      end
      let(:account_form) { AccountForm.new }

      before do
        account_form.process
      end

      it "should return total rejected transactions amount in the date range" do
        expect(account_form.transactions_total_amount).to eq(30)
      end
    end
  end
end
