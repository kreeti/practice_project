class AccountsController < ApplicationController
  def index
    @account_form = AccountForm.new(params)
    @account_form.process
  end

  def new
    @account = Account.new
  end

  def edit
    account
  end

  def list
    @accounts = Account.order_by_name
  end

  def create
    @account = Account.new(params[:account])

    if @account.save
      if params[:create_and_add].present?
        redirect_to new_account_path, notice: "Account created successfully"
      elsif params[:create].present?
        redirect_to list_accounts_path, notice: "Account created successfully"
      end
    else
      render "new"
    end
  end

  def update
    if account.update(params[:account])
      redirect_to list_accounts_path, notice: "Account updated successfully"
    else
      render "edit"
    end
  end

  def destroy
    @account = account
    if @account.destroy
      flash[:notice] = t(".success_delete_notice")
    else
      flash[:error] = @account.errors.full_messages.to_sentence
    end
    redirect_back(fallback_location: accounts_path)
  end

  private

  def account
    @account = Account.find(params[:id])
  end
end
