class Page < ActiveRecord::Base
  has_many :tasks
  has_many :users, through: :tasks

  validates :url, presence: true, uniqueness: {case_sensitive: false}
end
