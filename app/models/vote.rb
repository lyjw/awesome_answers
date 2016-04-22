class Vote < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  # A boolean - false is treated as nil. If :is_up is false - when testing .presence?, it will return false regardless of whether or not :is_up has a boolean value present. Thus, it is not ideal to validate for presence: true
  validates_inclusion_of :is_up, in: [true, false]
  validates :user_id, uniqueness: { scope: :question_id }

  scope :upvotes_count, -> { where(is_up: true).count }
  # def self.upvotes_count
  #   where(is_up: true).count
  # end

  scope :downvotes_count, -> { where(is_up: false).count }
  # def self.downvotes_count
  #   where(is_up: false).count
  # end

end
