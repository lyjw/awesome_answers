class User < ActiveRecord::Base

  scope :created_after, -> (days) { where("created_at <= NOW() - INTERVAL \'#{days} days\'")}

  # def self.created_after(days)
  #   where(["created_at <= NOW() - INTERVAL \'#{days} days\'"])
  # end

end
