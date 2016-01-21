FactoryGirl.define do

  factory :student do |s|
    s.name { Faker::Name.name }
  end

end