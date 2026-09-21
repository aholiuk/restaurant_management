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
end