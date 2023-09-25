require "rails_helper"

feature "Account" do
  before :each do
    login(User.create(email: "ppuja@kreeti.com"))
  end

  scenario "User creates a new account" do
    visit "accounts/new"
    fill_in "Name", with: "transport"
    click_button "Create"

    expect(page).to have_text("Account created successfully")
  end

  scenario "User creates a new account" do
    visit "accounts/new"
    fill_in "Name", with: "transport"
    click_button "Create & Add Another"

    expect(page).to have_text("Account created successfully")
  end

  scenario "User updates a  account" do
    account = create(:account)
    visit edit_account_path(account)
    fill_in "Name", with: "transport"
    click_button "Update"

    expect(page).to have_text("Account updated successfully")
  end
end
