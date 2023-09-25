class CreditTransactionsController < ApplicationController
  before_action :verified, only: [:edit, :update, :destroy]

  def new
    @credit_transaction = CreditTransaction.new
  end

  def show
    @credit_transaction = CreditTransaction.find(params[:id])
  end

  def create
    @credit_transaction = CreditTransaction.new(credit_transaction_params)
    @credit_transaction.user = current_user

    if @credit_transaction.save
      redirect_to transactions_path, notice: "credit transaction created successfully"
    else
      render "new"
    end
  end

  def edit
    @credit_transaction = CreditTransaction.find(params[:id])
  end

  def update
    @credit_transaction = CreditTransaction.find(params[:id])

    if @credit_transaction.update(credit_transaction_params)
      redirect_to @credit_transaction, notice: "Transaction updated successfully"
    else
      render "edit"
    end
  end

  def destroy
    @credit_transaction = CreditTransaction.find(params[:id])
    @credit_transaction.destroy
    redirect_to transactions_path, notice: "Transaction successfully deleted!!"
  end

  def approve
    @credit_transaction = CreditTransaction.find(params[:id])
    @credit_transaction.approve_transaction(current_user)

    return if request.xhr?

    redirect_to transactions_path, notice: "Transaction approved successfully"
  end

  def reject_transaction
    @credit_transaction = CreditTransaction.find(params[:id])
  end

  def reject
    @credit_transaction = CreditTransaction.find(params[:id])

    if @credit_transaction.reject(current_user, credit_transaction_params[:rejection_reason])
      redirect_to transactions_path, notice: "Transaction rejected successfully"
    else
      redirect_to transactions_path, alert: "Transaction could not be rejected"
    end
  end

  private

  def credit_transaction_params
    params.require(:credit_transaction).permit(:amount, :beneficiary_user_id, :transaction_on, :rejection_reason)
  end

  def verified
    @credit_transaction = CreditTransaction.find(params[:id])
    return unless @credit_transaction.verified?

    redirect_to transactions_path, alert: "Credit transaction cannot be updated or deleted."
  end
end
