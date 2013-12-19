FactoryGirl.define do
  factory :maillog do
    time { rand(1.month).ago }
    server_name { Faker::Lorem.word }
    daemon { Faker::Lorem.word }

    trait :today do
      time { rand(DateTime.now.hour.hour).ago }
    end

    trait :recent do
      time { rand(DateTime.now.minute.minute).ago }
    end
  end
end
