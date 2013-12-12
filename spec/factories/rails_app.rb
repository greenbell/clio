FactoryGirl.define do
  factory :rails_app do
    time { rand(1.month).ago }
    server_name { Faker::Lorem.word }
    level { Faker::Lorem.word }
    messages { 3.times.map { Faker::Lorem.sentence } }

    trait :today do
      time { rand(DateTime.now.to_f - Date.today.to_time.to_f).ago }
    end
  end
end
