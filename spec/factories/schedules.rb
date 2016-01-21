FactoryGirl.define do

  factory :schedule do |s|
    s.start_time { Date.now }
    s.end_time { Date.now }
    s.schedule_status {[0,1].sample }
    association :teacher, factory: :teacher
  end

end