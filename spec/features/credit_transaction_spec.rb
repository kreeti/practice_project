require "rails_helper"

feature "CreditTransaction" do
  before :each do
    login(User.create(name: "preeti puja", email: "ppuja@kreeti.com"))
  end

  scenario "user create a new credit transaction" do
    visit "credit_transactions/new"
    fill_in "credit_transaction_amount", with: 120
    fill_in "credit_transaction_transaction_on", with: Time.zone.today
    select("preeti puja", from: "credit_transaction_beneficiary_user_id")
    click_button "Create"

    expect(page).to have_text("credit transaction created successfully")
  end

  scenario "user updates a credit transaction" do
    credit_transaction = create(:credit_transaction)
    visit edit_credit_transaction_path(credit_transaction.id)
    fill_in "credit_transaction_amount", with: 120
    select("preeti puja", from: "credit_transaction_beneficiary_user_id")
    click_button "Update"

    expect(page).to have_text("Transaction updated successfully")
  end
end
