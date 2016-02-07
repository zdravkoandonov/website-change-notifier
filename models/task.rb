class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :page

  validates :frequency, presence: true
end
