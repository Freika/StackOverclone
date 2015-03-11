FactoryGirl.define do
  factory :question do
    title 'Title'
    body 'Body'

    factory :invalid_question do
      title nil
      body nil
    end
  end
end
