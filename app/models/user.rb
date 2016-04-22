class User < ActiveRecord::Base

  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify

  has_many :likes, dependent: :destroy
  # The 'source' option is used here because we used 'liked_questions' instead of 'questions' (convention) becuase we used 'has_many :questions' earlier.
  # Inside the 'like' model, there is no assiciation called 'liked_question', so we have to specify the source for Rails to know how to match it
  has_many :liked_questions, through: :likes, source: :question

  has_many :votes, dependent: :destroy
  has_many :voted_questions, through: :votes, source: :question

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
