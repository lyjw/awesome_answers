class User < ActiveRecord::Base

  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify

  # 1 - Adds attribute accessors: password and password_confirmation
  # These attribute values should not be stored in the database but will be accessible in memory temporarily (does not map to a field in the database), so that it can go through the BCrypt hashing algorithm. By default, Rails hides passwords from logs for security.
  # 2 - Adds validation: Password must be present on creation
  # 3 - If password confirmation is present, it will make sure it's equal to password
  # 4 - Password length should be less than or equal to 72 characters
  # 5 - It will hash the password using BCrypt and stores the hash digest in the password_digest field
  has_secure_password

  # These are accessible
  # attr_accessor :abc

  validates :first_name, presence: true
  validates :last_name, presence: true

  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: VALID_EMAIL_REGEX

  def full_name
    "#{first_name} #{last_name}"
  end

end
