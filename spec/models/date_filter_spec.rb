require "rails_helper"

describe DateFilter do
  context "when time_interval is monthly" do
    let(:account) { create(:account) }
    let(:transaction) { create(:transaction, account: account, amount: 10, date: Time.zone.today) }

    describe ".get_to_date_and_from_date" do
      subject { DateFilter.get_to_date_and_from_date(Transaction::MONTHLY) }

      it "should return a date range" do
        expect(subject.first).to eq(Time.zone.today.beginning_of_month)
        expect(subject.last).to eq(Time.zone.today.end_of_month)
      end
    end
  end

  context "when time_interval is yearly" do
    context "when current month is less than beginning month of financial year" do
      let(:date) { Date.new(Time.zone.today.year, Transaction::BEGINNING_MONTH_OF_FINANCIAL_YEAR - 1) }

      before do
        @t = Time.zone
        allow(@t).to receive(:today).and_return(date)
      end

      subject { DateFilter.get_to_date_and_from_date(Transaction::YEARLY) }

      it "should return a date_range" do
        expect(subject.first).to eq((date - 11.months).beginning_of_month)
        expect(subject.last).to eq(date.end_of_month)
      end
    end

    context "when current month is equal to beginning month of financial year" do
      let(:date) { Date.new(Time.zone.today.year, Transaction::BEGINNING_MONTH_OF_FINANCIAL_YEAR) }

      before do
        @t = Time.zone
        allow(@t).to receive(:today).and_return(date)
      end

      subject { DateFilter.get_to_date_and_from_date(Transaction::YEARLY) }

      it "should return a date_range" do
        expect(subject.first).to eq(date.beginning_of_month)
        expect(subject.last).to eq((date + 11.months).end_of_month)
      end
    end
  end

  context "when time_interval is quarterly" do
    context "when current month is less than beginning month of financial year" do
      let(:date) { Date.new(Time.zone.today.year, Transaction::BEGINNING_MONTH_OF_FINANCIAL_YEAR - 1) }

      before do
        @t = Time.zone
        allow(@t).to receive(:today).and_return(date)
      end

      subject { DateFilter.get_to_date_and_from_date(Transaction::QUARTERLY) }

      it "should return a date_range" do
        expect(subject.first).to eq((date - 2.months).beginning_of_month)
        expect(subject.last).to eq(date.end_of_month)
      end
    end

    context "when current month is equal to beginning month of financial year" do
      let(:date) { Date.new(Time.zone.today.year, Transaction::BEGINNING_MONTH_OF_FINANCIAL_YEAR) }

      before do
        @t = Time.zone
        allow(@t).to receive(:today).and_return(date)
      end

      subject { DateFilter.get_to_date_and_from_date(Transaction::QUARTERLY) }

      it "should return a date_range" do
        expect(subject.first).to eq(date.beginning_of_month)
        expect(subject.last).to eq((date + 2.months).end_of_month)
      end
    end
  end
end
