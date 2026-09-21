class Employee < ApplicationRecord
  has_secure_password

  ROLES = %w[server kitchen bar manager].freeze

  validates :name, presence: true
  validates :email, presence: true,
                     uniqueness: { case_sensitive: false },
                     format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, inclusion: { in: ROLES }
  validates :password, length: { minimum: 12 }, allow_nil: true

  normalizes :email, with: ->(email) { email.strip.downcase }

  def manager?
    role == "manager"
  end

  def kitchen?
    role == "kitchen"
  end

  def bar?
    role == "bar"
  end

  def server?
    role == "server"
  end

  def request_email_change!(new_email)
    self.unconfirmed_email = new_email
    self.confirmation_token = SecureRandom.hex(16)
    save!(validate: false) # neue E-Mail ist ja noch nicht die "echte" email-Spalte
    confirmation_token
  end

  def confirm_email_change!
    return false if unconfirmed_email.blank?

    update!(email: unconfirmed_email, unconfirmed_email: nil, confirmation_token: nil)
  end
end