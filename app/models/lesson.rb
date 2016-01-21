class Lesson < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :student
  belongs_to :subscription
end
