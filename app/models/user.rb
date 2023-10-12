class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze

  has_many :transactions, dependent: :destroy
  has_many :credit_transactions, dependent: :destroy

  has_one_time_password

  before_save { self.email = email.downcase } if :will_save_change_to_email?
  before_destroy :stop_destroy
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
  default_scope { where(is_active: true) }

  def self.from_omniauth(auth)
    user = find_by(email: auth.info.email)

    if user.present?
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.google_oauth_token = auth.credentials.token
      user.save
    end

    user
  end

  def deactivate!
    update(is_active: false)
  end

  def name_or_email
    name.presence || email
  end

  def stop_destroy
    throw abort
  end
end
