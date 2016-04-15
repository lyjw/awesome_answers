class Question < ActiveRecord::Base

  # The symbol provided for the associated record must be plural. A :dependent option must be provided and can be either:
    # - :destroy - which deletes all answers when the question is deleted # - :nullify - which makes 'question_id' NULL for all associated answers
  has_many :answers, dependent: :destroy
  belongs_to :category
  belongs_to :user

  validates(:title, {presence: true, uniqueness: {message: "must be unique"}})

  validates :body, length: { minimum: 5 }

  validates :view_count, numericality: { greater_than_or_equal_to: 0 }

  # VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  # validates :email, format: VALID_EMAIL_REGEX

  # Validates that the combination of title and body is unique
  # Title by itself and body by itself does not have to be unique
  # But the combination of the two must be unique
  validates :title, uniqueness: {scope: :body}

  # validate is used to reference a method that will be used for a custom validation
  validate :no_monkey

  # This will call the 'set_defaults' method after the initialize phase
  after_initialize :set_defaults

  # After running q.valid?, q.title will be titleized
  before_validation :titleize_title

  # Similar to:
  # scope :recent_three, lambda { last(3) }
  def self.recent_three
    # order("created_at DESC").limit(3)
    last(3)
  end

  def self.search(search_term)
    # Open to SQL injections (SQLi)
    # where("body ILIKE '%#{search_term}%' OR title ILIKE '%#{search_term}%'")

    # Replacing the conditions string with the array allows ActiveRecord to sanitize user input and avoid SQLi. It escapes problematic characterics, i.e. single quotes, backslashes...etc
    where(["title ILIKE ? OR body ILIKE ?", "%#{search_term}%", "%#{search_term}%"])
    # where(["title ILIKE :term OR body ILIKE :term", {term: "%#{search_term}"}])
  end

  def titleize(str)
    ignore = ['in', 'the', 'of', 'and', 'or', 'from']

    capitalizedString = str.split(" ").map do |word|
      if !ignore.include? word
        word.capitalize
      end
    end

    capitalizedString.join(" ");
  end

  def user_full_name
    user ? user.full_name : "Anonymous" 
  end

  private

  # Question.search("hello")
  # Returns all questions with "hello" in title or body

  def set_defaults
    # Setting view_count by calling a setter method
    self.view_count ||= 0
  end

  def titleize_title
    self.title = title.titleize
  end

  def no_monkey
    if title.present? && title.downcase.include?("monkey")
      errors.add(:title, "No monkeys!")
    end
  end

end
