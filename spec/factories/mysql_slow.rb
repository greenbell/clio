FactoryGirl.define do
  factory :mysql_slow do
    time { rand(1.month).ago }
    server_name { Faker::Lorem.word }
    host_ip { Faker::Internet.ip_v4_address }
    host { Faker::Internet.domain_name }
    user { Faker::Internet.user_name }
    query_time { Faker::Number.number(3) }
    lock_time { Faker::Number.number(3) }
    rows_sent { Faker::Number.number(3) }
    rows_examined { Faker::Number.number(3) }
    sql { Faker::Lorem.paragraph }

    trait :today do
      time { rand(DateTime.now.hour.hour).ago }
    end
    trait :recent do
      time { rand(DateTime.now.minute.minute).ago }
    end
  end
end
