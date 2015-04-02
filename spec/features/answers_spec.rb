require 'rails_helper'

feature 'Interacting with answers' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: another_user) }

  context 'answer creating' do
    scenario 'Authenticated user can leave an answer to question', js: true do
      sign_in_with(user.email, user.password)
      visit question_path(question)

      fill_in 'Your answer', with: 'That means you gonna be Spiderman!'
      click_on 'Add answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'That means you gonna be Spiderman!'
      end
    end

    scenario 'User tries to create empty answer', js: true do
      sign_in_with(user.email, user.password)
      visit question_path(question)

      click_on 'Add answer'

      expect(page).to have_content "Body can't be blank"
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

  context 'Answer editing' do
    given!(:answer) { create(:answer, user: another_user, question: question) }

    scenario "Answer's author can edit his answer", js: true do
      sign_in_with(another_user.email, another_user.password)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_link 'Edit'

        click_on 'Edit'

        first('#answer_body').set('This is my answer')
        click_on 'Update Answer'
        expect(page).to have_content 'This is my answer'
        expect(page).to_not have_content answer.body
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'Unauthenticated user tries to edit answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end

    scenario "Authenticated user tries to edit other's user answer" do
      sign_in_with(user.email, user.password)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  context 'Answer deleting' do
    given!(:answer) { create(:answer, user: another_user, question: question, body: 'Brilliant answer') }

    scenario "Answer's author can delete his answer", js: true do
      sign_in_with(another_user.email, another_user.password)
      visit question_path(question)

      within "#answer_#{answer.id}" do
        expect(page).to have_link 'Delete'
        click_on 'Delete'
      end

      expect(page).to_not have_content answer.body
    end

    scenario "User can't see link to another user's answer deletion" do
      visit question_path(question)
      within "#answer_#{answer.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  scenario "question's author can mark answer as best", js: true do
    first_answer  = create(:answer, question: question, user: another_user)
    second_answer = create(:answer, question: question, user: another_user)

    sign_in_with(another_user.email, another_user.password)
    visit question_path(question)

    within first('.answer') do
      click_on 'Best'
    end

    expect(page).to have_selector('.best-answer')

  end
end
