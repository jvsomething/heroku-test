FactoryGirl.define do

  factory :lessons do |l|
    l.lesson_date { Date.today }
    l.lesson_status { [0,1].sample }
    association :schedule, factory: :schedule
    association :student, factory: :student
    association :subscription, factory: :subscription
  end

end