FactoryGirl.define do
  factory :mysql_slow do
    time { rand(1.month).ago }
    server_name { Faker::Lorem.word }
    host_ip { Faker::Internet.ip_v4_address }
    host { Faker::Internet.domain_name }
    user { Faker::Internet.user_name }
    query_time { Faker::Number.number(2) }
    lock_time { Faker::Number.number(2) }
    rows_sent { Faker::Number.number(2) }
    rows_examined { Faker::Number.number(3) }
    sql { Faker::Lorem.paragraph }
  end
end
