# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :apache_access do
    time { rand(1.month).ago }
    vhost { Faker::Internet.domain_name }
    host { Faker::Internet.ip_v4_address }
    user { Faker::Internet.user_name }
    path "/"
    code 200
    size { Faker::Number.number(3) }
    referer { Faker::Internet.url }
    agent ""
    forwarded { Faker::Internet.ip_v4_address }
    server_name { Faker::Lorem.word }
    after(:build) do |log, evaluator|
      log.method = 200
    end
  end
end