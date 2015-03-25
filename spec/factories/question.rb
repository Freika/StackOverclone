FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Title ##{n}" }
    body 'Body'
    user_id nil

    factory :invalid_question do
      title nil
      body nil
    end
  end
end
