FactoryGirl.define do
  factory :rails_production do
    time { rand(1.month).ago }
    server_name { Faker::Lorem.word }
    app { Faker::Lorem.word }
    level { Faker::Lorem.word }
    messages { 3.times.map { Faker::Lorem.sentence } }

    trait :today do
      time { rand(DateTime.now.hour.hour).ago }
    end

    trait :recent do
      time { rand(DateTime.now.minute.minute).ago }
    end

    trait :fatal do
      level "FATAL"
    end
    trait :error do
      level "ERROR"
    end
    trait :warn do
      level "WARN"
    end
    trait :info do
      level "info"
    end
    trait :debug do
      level "DEBUG"
    end
  end
end
