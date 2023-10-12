class TransactionsController < ApplicationController
  before_action :verified, only: [:edit, :update, :destroy]
  def index
    @transaction_form = TransactionForm.new(params)
    @transaction_form.process
    @transactions = @transaction_form.transactions.order_transactions_in_group
    @credit_transactions = @transaction_form.credit_transactions.order_credit_transactions_in_group
    @credit_transaction_amount = @credit_transactions.total_credit_transaction_amount
    previous_transactions = Transaction.previous_transactions(@transaction_form.from_date)
    previous_credit_transactions = CreditTransaction.previous_credit_transactions(@transaction_form.from_date)
    @balance_brought_forward = previous_credit_transactions.sum(:amount) - previous_transactions.sum(:amount)
    @cash_in_hand = CreditTransaction.total_credit_transaction_amount - Transaction.total_transaction_amount
  end

  def new
    if params[:account_id]
      @account = Account.find(params[:account_id])
    end

    @transaction = Transaction.new
  end

  def show
    transaction
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.user = current_user

    if @transaction.save
      if params[:create_and_add].present?
        @transaction.add_attachments(params[:attachments]) if params[:attachments]
        redirect_to new_transaction_path, notice: "Transaction created successfully"
      elsif params[:create].present?
        @transaction.add_attachments(params[:attachments]) if params[:attachments]
        redirect_to transactions_path, notice: "Transaction created successfully"
      end
    else
      render "new"
    end
  end

  def edit
    transaction
  end

  def update
    @transaction = transaction
    if @transaction.update(transaction_params)
      if params[:attachments]
        @transaction.add_attachments(params[:attachments])
      end

      redirect_to @transaction, notice: "Transaction is updated"
    else
      render "edit"
    end
  end

  def destroy
    transaction.destroy
    redirect_back(fallback_location: transactions_path, notice: "Transaction deleted successfully")
  end

  def reject_transaction
    transaction
  end

  def approve
    transaction.approve_transaction(current_user)

    return if request.xhr? request.xhr?

    redirect_to transactions_path, notice: "Transaction approved successfully"
  end

  def reject
    if transaction.reject(current_user, transaction_params[:rejection_reason])
      redirect_to transactions_path, notice: "Transaction rejected successfully"
    else
      redirect_to transactions_path, alert: "Transaction could not be rejected"
    end
  end

  def remove_attachment
    @transaction = transaction
    if !@transaction.approved? && @transaction.remove_attachment(params[:attachment_id])
      redirect_to @transaction, notice: "Attachment Deleted Successfully"
    else
      redirect_to @transaction, notice: "Attachment cannot be deleted"
    end
  end

  private

  def transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(
      :date, :amount, :description, :account_id, :rejection_reason,
      attachments_attributes: [:_destroy, :id]
    )
  end

  def verified
    return unless transaction.verified?

    redirect_to transactions_path, alert: "Transaction can not be updated or deleted"
  end
end
