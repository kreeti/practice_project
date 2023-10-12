class ReportsController < ApplicationController
  def index
    selected_year = params[:year] || Time.zone.today.year
    transaction_data = Transaction.where(rejected_by: nil)
                                  .select("DATE_FORMAT(date, '%c') AS month, sum(amount) AS total")
                                  .where("YEAR(date) = ?", selected_year).group("month")
                                  .map {|t| [t.month.to_i, t.total.to_f]}

    @transaction_data = (1..12).map { |month| [month_name(month), transaction_data.assoc(month)&.last || 0] }
  end

  private

  def month_name(month)
    Date::ABBR_MONTHNAMES[month]
  end
end
