class TransactionForm
  attr_reader :from_date, :to_date, :date_range, :credit_transactions, :time_interval_params, :transactions, :account

  def initialize(params = {})
    @time_interval_params = params[:time_interval] || "Monthly"
    @current_params       = params[:current]
    @previous_params      = params[:previous]
    @upcoming_params      = params[:upcoming]
    @to_date_params       = params[:to_date]
    @from_date_params     = params[:from_date]
    @status_params        = params[:status]

    if params[:account_id].present?
      @account = Account.find(params[:account_id])
      @transactions = @account.transactions
    end

    @credit_transactions  = CreditTransaction.all
    @transactions       ||= Transaction.all
  end

  def process
    if @previous_params.present? || @upcoming_params.present? || @current_params.present?
      @from_date = Date.parse(@from_date_params) if @from_date_params.present?
      @to_date = Date.parse(@to_date_params) if @to_date_params.present?

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
      elsif @upcoming_params.present?
        @from_date += previous
        @to_date   += previous
      end

      @to_date = @to_date.end_of_month
    else
      @from_date, @to_date = DateFilter.get_to_date_and_from_date(@time_interval_params)
    end

    if @status_params.present?
      @transactions = @transactions.filter_by_status(@status_params)
    end

    @date_range          = @from_date..@to_date
    @credit_transactions = @credit_transactions.between(@date_range)
    @transactions        = @transactions.between(@date_range)
  end
end
