require "rails_helper"

describe TransactionForm do
  let(:account) { create(:account) }

  describe "#process" do
    context "when previous params and upcoming params are not present" do
      context "when default filteration is monthly" do
        let!(:transaction)                { create(:transaction, date: Time.zone.today, account: account) }
        let!(:another_transaction)        { create(:transaction, date: 1.month.ago, account: account) }
        let!(:credit_transaction)         { create(:credit_transaction, transaction_on: Time.zone.today) }
        let!(:another_credit_transaction) { create(:credit_transaction, transaction_on: 1.month.ago) }
        let(:transaction_form)            { TransactionForm.new }

        before do
          transaction_form.process
        end

        it "should return transaction within the current month range" do
          expect(transaction_form.transactions).to include(transaction)
          expect(transaction_form.credit_transactions).to include(credit_transaction)
        end

        it "should not return transaction outside the current month range" do
          expect(transaction_form.transactions).not_to include(another_transaction)
          expect(transaction_form.credit_transactions).not_to include(another_credit_transaction)
        end
      end

      context "when user selects quarterly" do
        let!(:transaction) do
          create(:transaction, date: Time.zone.today, account: account, amount: 100)
        end
        let!(:another_transaction) do
          create(:transaction, date: Time.zone.today, account: account, amount: 300)
        end
        let!(:credit_transaction) do
          create(:credit_transaction, transaction_on: Time.zone.today, amount: 100)
        end
        let!(:another_credit_transaction) do
          create(:credit_transaction, transaction_on: Time.zone.today, amount: 300)
        end
        let(:transaction_form) do
          TransactionForm.new(time_interval: "Quarterly")
        end

        before do
          transaction_form.process
        end

        it "should return total transaction amount in that date range" do
          expect(transaction_form.transactions.total_transaction_amount).to eq(BigDecimal("400"))
          expect(transaction_form.credit_transactions.sum(:amount)).to eq(BigDecimal("400"))
        end
      end
    end
  end

  context "when previous params  present" do
    let!(:transaction)                { create(:transaction, date: Time.zone.today, account: account) }
    let!(:another_transaction)        { create(:transaction, date: 1.month.ago, account: account) }
    let!(:credit_transaction)         { create(:credit_transaction, transaction_on: Time.zone.today) }
    let!(:another_credit_transaction) { create(:credit_transaction, transaction_on: 1.month.ago) }
    let(:transaction_form)            do
      TransactionForm.new(previous: true, from_date: Time.zone.today.beginning_of_month.to_s,
                          to_date: Time.zone.today.end_of_month.to_s)
    end

    before do
      transaction_form.process
    end

    it "should return transaction within the previous month range" do
      expect(transaction_form.transactions).to include(another_transaction)
      expect(transaction_form.credit_transactions).to include(another_credit_transaction)
    end

    it "should not return transaction in the previous month range" do
      expect(transaction_form.transactions).not_to include(transaction)
      expect(transaction_form.credit_transactions).not_to include(credit_transaction)
    end
  end

  context "when upcoming params  present" do
    let!(:transaction) do
      create(:transaction, date: Time.zone.today, account: account)
    end
    let!(:another_transaction) do
      create(:transaction, date: Time.zone.today + 1.month, account: account)
    end
    let!(:credit_transaction) do
      create(:credit_transaction, transaction_on: Time.zone.today)
    end
    let!(:another_credit_transaction) do
      create(:credit_transaction, transaction_on: Time.zone.today + 1.month)
    end
    let(:transaction_form) do
      TransactionForm.new(upcoming: true, from_date: Time.zone.today.beginning_of_month.to_s,
                          to_date: Time.zone.today.end_of_month.to_s)
    end

    before do
      transaction_form.process
    end

    it "should return transaction within the upcoming month range" do
      expect(transaction_form.transactions).to include(another_transaction)
      expect(transaction_form.credit_transactions).to include(another_credit_transaction)
    end

    it "should not return transaction in the upcoming month range" do
      expect(transaction_form.transactions).not_to include(transaction)
      expect(transaction_form.credit_transactions).not_to include(credit_transaction)
    end
  end

  context "when status params  present" do
    let!(:user)                { create(:user) }
    let!(:transaction)         do
      create(:transaction, date: Time.zone.today, account: account, rejected_by: user.id)
    end
    let!(:another_transaction) do
      create(:transaction, date: Time.zone.today + 1.month, account: account)
    end
    let(:transaction_form) do
      TransactionForm.new(status: "rejected_transactions")
    end

    before do
      transaction_form.process
    end

    it "should return transaction with the specific status" do
      expect(transaction_form.transactions).to include(transaction)
    end

    it "should not return transaction in the upcoming month range" do
      expect(transaction_form.transactions).not_to include(another_transaction)
    end
  end
end
