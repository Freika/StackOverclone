require 'rails_helper'

feature 'Question' do

  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, user: user1) }

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

    expect(page).to_not have_link 'Ask question'
  end

  scenario 'Authenticated user can leave an answer to question' do
    sign_in_with(user.email, user.password)
    visit question_path(question)

    fill_in 'Your answer', with: 'That means you gonna be Spiderman!'
    click_on 'Add answer'

    expect(page).to have_content 'Answer was added'
    expect(page).to have_content 'That means you gonna be Spiderman!'
  end

  scenario 'User can view questions list' do
    5.times { |n| Question.create(title: "Question number #{n}", body: 'Lorem ipsum dolor.', user: user1) }
    visit questions_path

    expect(page).to have_selector('p.question', count: 5)
  end

  scenario 'User or guest can see question and appropriate answers' do
    answer = create(:answer, question: question, user: user1)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end

  scenario 'Unauthenticated user cannot leave answers' do
    visit question_path(question)

    expect(page).to have_content 'Sign in or sign up to leave answers'
    expect(page).to_not have_content 'Add answer'
  end

  scenario "Question's author can delete his question" do
    sign_in_with(user1.email, user1.password)
    visit question_path(question)

    expect(page).to have_content 'Delete question'
  end

  scenario "User cannot delete questions he don't authored" do
    sign_in_with(user.email, user.password)
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end

end
