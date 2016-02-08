class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :page

  validates :name, presence: true
  validates :frequency, presence: true
end
