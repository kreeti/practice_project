module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:default] = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: "12345",
      info: {
        email: "ppuja@kreeti.com",
        first_name: "preeti",
        last_name: "puja"
      },
      credentials: {
        google_client_id: "12345",
        google_client_secret: "ABCD"
      }
    )
  end
end
