require 'rails_helper'

feature 'Interacting with questions' do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: another_user) }

  scenario 'Authenticated user creates question' do
    sign_in_with(user.email, user.password)
    visit questions_path

    click_on 'Ask new question'
    fill_in 'Title', with: 'What the hell is wrong with me?'
    fill_in 'Body', with: 'Radioactive spider bites me yesterday in the lab, what should I do with this sh*t?'
    click_on 'Create Question'

    expect(page).to have_content 'Question was successfully created'
    expect(page).to have_content 'What the hell is wrong with me?'
    expect(page).to have_content 'Radioactive spider bites me yesterday in the lab, what should I do with this sh*t?'
  end

  scenario 'Unauthenticated user cannot create question' do
    visit questions_path
    expect(page).to_not have_link 'Ask question'
  end

  scenario 'User can view questions list' do
    questions = create_list(:question, 5, user: another_user)
    visit questions_path

    questions.each do |question|
      expect(page).to have_link question.title
    end
  end

  scenario "Question's author can delete his question" do
    sign_in_with(another_user.email, another_user.password)
    visit question_path(question)

    expect(page).to have_content 'Delete question'
  end

  scenario "User cannot delete questions he don't authored" do
    sign_in_with(user.email, user.password)
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end
end
