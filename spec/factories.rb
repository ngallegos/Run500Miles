FactoryBot.define do
  factory :user do
    fname                 { "Nick" }
    lname                 { "Gallegos" }
    email                 { "nick.gallegos@example.com" }
    password              { "foobar" }
    password_confirmation { "foobar" }
    secret_word           { "angusbeef" }
  end

  sequence :fname do |n|
    "First#{n}"
  end

  sequence :lname do |n|
    "Last#{n}"
  end

  sequence :email do |n|
    "person-#{n}@example.com"
  end

  factory :activity do
    comment       { "comment" }
    activity_date { Date.today }
    distance      { 2.0 }
    hours         { 0 }
    minutes       { 25 }
    activity_type { 1 }
    association :user
  end
end
