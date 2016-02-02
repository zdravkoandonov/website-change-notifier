class User < ActiveRecord::Base
  validates :email, presence: true
  validates :username, presence: true, uniqueness: {case_sensitive: false}
  validates :password, presence: true
end
