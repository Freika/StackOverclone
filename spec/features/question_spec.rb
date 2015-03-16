require 'rails_helper'

feature 'Question' do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in_with(user.email, user.password)
    visit questions_path

    click_on 'Ask new question'
    fill_in 'Title', with: 'What the hell is wrong with me?'
    fill_in 'Body', with: 'Radioactive spider bites me yesterday in the lab, what should I do with this sh*t?'
    click_on 'Create Question'

    expect(page).to have_content 'Question was successfully created'
  end

  scenario 'Unauthenticated user cannot create question' do
    visit questions_path
    click_on 'Ask new question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user can leave an answer to question' do
    question = create(:question)
    visit question_path(question)

    fill_in 'Your answer', with: 'That means you gonna be Spiderman!'
    click_on 'Add answer'

    expect(page).to have_content 'Answer was added'
    expect(page).to have_content 'That means you gonna be Spiderman!'
  end

end
