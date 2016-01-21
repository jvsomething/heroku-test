FactoryGirl.define do

  factory :teacher do |t|
    t.name { Faker::Name.name }
    t.gender { [true, false].sample }
    t.nationality {}
  end

end