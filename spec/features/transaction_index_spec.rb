require "rails_helper"

feature "User visits the index page" do
  before :each do
    login(User.create(email: "ppuja@kreeti.com"))
  end

  scenario "common" do
    transaction        = create(:transaction, date: Time.zone.today)
    credit_transaction = create(:credit_transaction, transaction_on: Time.zone.today)
    visit transactions_path

    expect(page).to have_selector(:link_or_button, "Add")
    expect(page).to have_content(transaction.amount)
    expect(page).to have_link(href: edit_transaction_path(transaction))
    expect(page).to have_link(href: transaction_path(transaction))
    expect(page).to have_content(credit_transaction.amount)
    expect(page).to have_link(href: edit_credit_transaction_path(credit_transaction))
    expect(page).to have_link(href: credit_transaction_path(credit_transaction))
  end

  scenario "and selects yearly", js: true do
    user                       = create(:user)
    account                    = create(:account)
    transaction                = create(:transaction, date: Time.zone.today, account: account)
    credit_transaction         = create(:credit_transaction, transaction_on: Time.zone.today, beneficiary_user: user)

    visit transactions_path

    select("Yearly", from: "time_interval")

    within(".transactions-list") do
      expect(page).to have_content(transaction.amount)
      expect(page).to have_content(account.name)
    end

    within(".credit-transactions-list") do
      expect(page).to have_content(credit_transaction.amount)
      expect(page).to have_content(user.name)
    end
  end

  scenario "and selects monthly", js: true do
    user                       = create(:user)
    account                    = create(:account)
    transaction                = create(:transaction, date: Time.zone.today, account: account)
    credit_transaction         = create(:credit_transaction, transaction_on: Time.zone.today, beneficiary_user: user)
    visit transactions_path

    select("Monthly", from: "time_interval")

    within(".transactions-list") do
      expect(page).to have_content(transaction.amount)
      expect(page).to have_content(account.name)
    end

    within(".credit-transactions-list") do
      expect(page).to have_content(credit_transaction.amount)
      expect(page).to have_content(user.name)
    end
  end

  scenario "and selects quarterly", js: true do
    user                       = create(:user)
    account                    = create(:account)
    transaction                = create(:transaction, date: Time.zone.today, account: account)
    credit_transaction         = create(:credit_transaction, transaction_on: Time.zone.today, beneficiary_user: user)
    visit transactions_path

    select("Quarterly", from: "time_interval")

    within(".transactions-list") do
      expect(page).to have_content(transaction.amount)
      expect(page).to have_content(account.name)
    end

    within(".credit-transactions-list") do
      expect(page).to have_content(credit_transaction.amount)
      expect(page).to have_content(user.name)
    end
  end

  scenario "and user clicks <<" do
    user                       = create(:user)
    account                    = create(:account)
    transaction                = create(:transaction, date: Time.zone.today)
    another_transaction        = create(:transaction, date: 1.month.ago, account: account)
    credit_transaction         = create(:credit_transaction, transaction_on: Time.zone.today)
    another_credit_transaction = create(:credit_transaction, transaction_on: 1.month.ago, beneficiary_user: user)
    visit transactions_path
    click_button("<<")

    within(".transactions-list") do
      expect(page).to have_content(another_transaction.amount)
      expect(page).to have_content(account.name)
    end

    within(".credit-transactions-list") do
      expect(page).to have_content(another_credit_transaction.amount)
      expect(page).to have_content(user.name)
    end
  end

  scenario "and user clicks >>" do
    user                       = create(:user)
    account                    = create(:account)
    transaction                = create(:transaction, date: Time.zone.today)
    another_transaction        = create(:transaction, date: Time.zone.today + 1.month, account: account)
    credit_transaction         = create(:credit_transaction, transaction_on: Time.zone.today)
    another_credit_transaction = create(:credit_transaction,
                                        transaction_on: Time.zone.today + 1.month,
                                        beneficiary_user: user)

    visit transactions_path
    click_button(">>")

    within(".transactions-list") do
      expect(page).to have_content(another_transaction.amount)
      expect(page).to have_content(account.name)
    end

    within(".credit-transactions-list") do
      expect(page).to have_content(another_credit_transaction.amount)
      expect(page).to have_content(user.name)
    end
  end
end
