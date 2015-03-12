FactoryGirl.define do
  factory :answer do
    body 'Body'

    factory :invalid_answer do
      body nil
    end
  end
end
