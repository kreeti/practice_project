require "rails_helper"

describe CreditTransactionsController do
  let!(:credit_transaction) { create(:credit_transaction) }

  before do
    allow(controller).to receive(:current_user) { create(:user) }
  end

  describe "#show" do
    it "should render show page" do
      get :show, params: { id: credit_transaction.id }
      expect(response).to render_template("show")
    end
  end

  describe "#create" do
    let(:credit_transaction_params) do
      { credit_transaction: { amount: 100, transaction_on: Time.zone.today,
                              beneficiary_user_id: create(:user).id } }
    end

    it "should create credit transaction" do
      expect { post :create, params: credit_transaction_params }.to change { CreditTransaction.count }.by(1)
    end

    it "should redirect to credit_transaction show page" do
      post :create, params: credit_transaction_params
      expect(response).to redirect_to transactions_path
    end
  end

  describe "#update" do
    let(:another_credit_transaction_params) { { credit_transaction: { amount: 10 } } }

    it "should update the credit transaction" do
      put :update, params: another_credit_transaction_params.merge(id: credit_transaction.id)
      expect(credit_transaction.reload.amount).to eq(10)
    end
  end

  describe "#destroy" do
    it "should delete an transaction" do
      expect { delete :destroy, params: { id: credit_transaction } }.to change { CreditTransaction.count }.by(-1)
    end

    it "should redirect to transaction index page" do
      delete :destroy, params: { id: credit_transaction }
      expect(response).to redirect_to transactions_path
    end
  end
end
