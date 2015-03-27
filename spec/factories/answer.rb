FactoryGirl.define do
  factory :answer do
    body 'Body'
    question_id nil
    user_id nil

    factory :invalid_answer do
      body nil
    end
  end
end
