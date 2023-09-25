require "rails_helper"

feature "Transaction" do
  before :each do
    login(User.create(name: "preeti puja", email: "ppuja@kreeti.com"))
    account = create(:account, name: "lodging")
  end

  scenario "user create a new transaction" do
    visit "transactions/new"
    fill_in "transaction_amount", with: 100
    select("lodging", from: "transaction_account_id")
    fill_in "transaction_date", with: "10/10/2016"
    click_button "Create"

    expect(page).to have_text("Transaction created successfully")
  end

  scenario "user updates a transaction" do
    transaction = create(:transaction)
    visit edit_transaction_path(transaction.id)
    fill_in "transaction_amount", with: 100
    select("lodging", from: "transaction_account_id")
    fill_in "transaction_date", with: "10/10/2016"
    click_button "Update"

    expect(page).to have_text("Transaction is updated")
  end
end
