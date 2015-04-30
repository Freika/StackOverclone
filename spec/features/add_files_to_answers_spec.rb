require 'rails_helper'

feature 'Add files to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in_with(user.email, user.password)
    visit question_path(question)
  end

  scenario 'User adds file to answer', js: true do
    fill_in 'Your answer', with: 'Your answer'
    attach_file 'File', "#{Rails.root}/spec/support/files/stark.png"
    click_on 'Add attachment'
    within '.fields:not(:first-child)' do
      attach_file 'File', "#{Rails.root}/spec/support/files/facepalm.gif"
    end
    click_on 'Add answer'

    within '.answers' do
      expect(page).to have_link 'stark.png', href: '/uploads/attachment/file/1/stark.png'
      expect(page).to have_link 'facepalm.gif', href: '/uploads/attachment/file/2/facepalm.gif'
    end
  end
end
