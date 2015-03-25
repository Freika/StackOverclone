require 'rails_helper'

feature 'Interacting with answers' do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: another_user) }

  scenario 'Authenticated user can leave an answer to question' do
    sign_in_with(user.email, user.password)
    visit question_path(question)

    fill_in 'Your answer', with: 'That means you gonna be Spiderman!'
    click_on 'Add answer'

    expect(page).to have_content 'Answer was added'
    expect(page).to have_content 'That means you gonna be Spiderman!'
  end

  scenario 'User or guest can see question and appropriate answers' do
    answers = create_list(:answer, 3, question: question, user: another_user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'Unauthenticated user cannot leave answers' do
    visit question_path(question)

    expect(page).to have_content 'Sign in or sign up to leave answers'
    expect(page).to_not have_content 'Add answer'
  end
end
