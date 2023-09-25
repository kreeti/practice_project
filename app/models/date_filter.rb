class DateFilter
  def self.get_to_date_and_from_date(time_interval)
    start_year = if Time.zone.today.month < Transaction::BEGINNING_MONTH_OF_FINANCIAL_YEAR
                   Time.zone.today.year - 1
                 else
                   Time.zone.today.year
                 end

    beginning_date_of_financial_year = Date.new(start_year,
                                                Transaction::BEGINNING_MONTH_OF_FINANCIAL_YEAR).beginning_of_month

    if time_interval == Transaction::YEARLY
      from_date = beginning_date_of_financial_year
      to_date = beginning_date_of_financial_year.since(11.months).end_of_month.to_date
    elsif time_interval == Transaction::QUARTERLY
      beginning_month_of_financial_year = beginning_date_of_financial_year.month
      first_month_of_quarter = [beginning_month_of_financial_year, (beginning_month_of_financial_year + 3) % 12,
                                (beginning_month_of_financial_year + 6) % 12,
                                (beginning_month_of_financial_year + 9) % 12].sort.reverse.detect do |m|
        m <= Time.zone.today.month
      end
      from_date = Time.zone.today.beginning_of_month.change(month: first_month_of_quarter)
      to_date = from_date.since(2.months).end_of_month
    else
      from_date = Time.zone.today.beginning_of_month
      to_date = Time.zone.today.end_of_month
    end

    [from_date.to_date, to_date.to_date]
  end
end
