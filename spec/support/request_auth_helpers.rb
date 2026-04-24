module RequestAuthHelpers
  DEFAULT_PASSWORD = "password123".freeze

  def create_user(name: "Test User", email: "user#{SecureRandom.hex(4)}@example.com", password: DEFAULT_PASSWORD)
    User.create!(
      name: name,
      email: email,
      password: password,
      password_confirmation: password
    )
  end

  def sign_in_as(user, password: DEFAULT_PASSWORD)
    post login_path, params: {
      session: {
        email: user.email,
        password: password
      }
    }
  end
end
