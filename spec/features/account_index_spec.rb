require "rails_helper"

feature "User visits the index page" do
  before :each do
    login(User.create(email: "ppuja@kreeti.com"))
  end

  scenario "common" do
    account = create(:account)
    transaction = create(:transaction, account: account)
    visit accounts_path

    expect(page).to have_selector(:link_or_button, "Add")
    expect(page).to have_content(account.name)
    expect(page).to have_link(href: edit_account_path(account))
    expect(page).to have_link(href: account_path(account))
    expect(page).to have_link(href: new_transaction_path(account_id: account))
  end

  scenario "and user selects yearly", js: true do
    transaction = create(:transaction, date: Time.zone.today)
    another_transaction = create(:transaction, date: 2.years.ago)
    visit accounts_path

    select("Yearly", from: "time_interval")
    within(".user") do
      expect(page).to have_content(transaction.account.name)
      expect(page).not_to have_content(another_transaction.account.name)
    end
  end

  scenario "and user selects monthly", js: true do
    transaction = create(:transaction, date: Time.zone.today)
    another_transaction = create(:transaction, date: 2.months.ago)
    visit accounts_path

    select("Monthly", from: "time_interval")
    within(".user") do
      expect(page).to have_content(transaction.account.name)
      expect(page).not_to have_content(another_transaction.account.name)
    end
  end

  scenario "and user selects quarterly", js: true do
    transaction = create(:transaction, date: Time.zone.today)
    another_transaction = create(:transaction, date: 3.months.ago)
    visit accounts_path

    select("Quarterly", from: "time_interval")
    within(".user") do
      expect(page).to have_content(transaction.account.name)
      expect(page).not_to have_content(another_transaction.account.name)
    end
  end

  scenario "and user clicks <<" do
    transaction = create(:transaction, amount: 100, date: Time.zone.today)
    another_transaction = create(:transaction, amount: 200, date: 1.month.ago)
    visit accounts_path

    click_button("<<")

    within(".user") do
      expect(page).to have_content(another_transaction.account.name)
      expect(page).not_to have_content(transaction.account.name)
    end
  end

  scenario "and user clicks >>" do
    transaction = create(:transaction, amount: 100, date: Time.zone.today)
    another_transaction = create(:transaction, amount: 200, date: Time.zone.today + 1.month)
    visit accounts_path

    click_button(">>")

    within(".user") do
      expect(page).to have_content(another_transaction.account.name)
      expect(page).not_to have_content(transaction.account.name)
    end
  end
end
