require "rails_helper"

module LoginHelper
  def login(user)
    mock_auth_hash
    visit root_path
    expect(page).to have_content("Sign in with Google")
    click_link "Sign in with Google"
    visit two_factor_authentication_session_path(user)
    expect(page).to have_content("Two Factor Authentication")
    fill_in "otp", with: user.otp_code
    click_button("Authenticate")
    visit transactions_path
    expect(page).to have_css("a.fa.fa-sign-out")
  end
end
