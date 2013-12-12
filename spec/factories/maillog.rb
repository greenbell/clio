FactoryGirl.define do
  factory :maillog do
    time { rand(1.month).ago }
    server_name { Faker::Lorem.word }
    daemon { Faker::Lorem.word }

    trait :today do
      time { rand(DateTime.now.to_f - Date.today.to_time.to_f).ago }
    end
  end
end
