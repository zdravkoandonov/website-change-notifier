class Task < ActiveRecord::Base
  has_and_belongs_to_many :users

  validates :url, presence: true, uniqueness: {case_sensitive: false}
  validates :frequency, presence: true
end
