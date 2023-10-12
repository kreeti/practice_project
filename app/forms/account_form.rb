class AccountForm
  attr_reader :name, :from_date, :to_date, :date_range, :accounts, :time_interval_params

  def initialize(params = {})
    @time_interval_params = params[:time_interval]
    @previous_params      = params[:previous]
    @upcoming_params      = params[:upcoming]
    @to_date_params       = params[:to_date]
    @from_date_params     = params[:from_date]
    @account_id_params    = params[:account_id]
    @accounts             = Account.all
  end

  def process
    if @previous_params.present? || @upcoming_params.present?
      @from_date = Date.parse(@from_date_params) if @from_date_params.present?
      @to_date   = Date.parse(@to_date_params) if @to_date_params.present?

      previous = if @time_interval_params == "Yearly"
                   1.year
                 elsif @time_interval_params == "Quarterly"
                   3.months
                 else
                   1.month
                 end

      if @previous_params.present?
        @from_date -= previous
        @to_date   -= previous
      else
        @from_date += previous
        @to_date   += previous
      end

      @to_date = @to_date.end_of_month
    else
      @from_date, @to_date = DateFilter.get_to_date_and_from_date(@time_interval_params)
    end

    sql_query = "SELECT accounts.name, COUNT(transactions.id) AS transaction_count,
                  SUM(transactions.amount) AS total_transaction_amount,
                  SUM(if(transactions.approved_by, transactions.amount, 0)) AS total_approved,
                  SUM(if(transactions.rejected_by, transactions.amount, 0)) AS total_rejected,
                  accounts.id AS account_id
                  FROM `accounts`
                  INNER JOIN `transactions` ON `transactions`.`account_id` = `accounts`.`id`
                  WHERE (`transactions`.`date` BETWEEN '#{@from_date}' AND '#{@to_date}')"
    sql_query << " AND `accounts`.`id` = '#{@account_id_params}'" if @account_id_params.present?
    sql_query << " GROUP BY transactions.account_id"

    @accounts = ActiveRecord::Base.connection.exec_query(sql_query)
  end

  def total_number_of_transactions
    @accounts.map { |a| a["transaction_count"] }.sum
  end

  def approved_transaction_total_amount
    @accounts.map { |a| a["total_approved"] }.sum
  end

  def pending_transaction_total_amount
    @accounts.map { |a| (a["total_transaction_amount"] - (a["total_approved"] + a["total_rejected"])) }.sum
  end

  def rejected_transaction_total_amount
    @accounts.map { |a| a["total_rejected"] }.sum
  end

  def transactions_total_amount
    @accounts.map { |a| a["total_transaction_amount"] }.sum
  end
end
