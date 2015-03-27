FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password '00000000'
    password_confirmation '00000000'
  end
end
