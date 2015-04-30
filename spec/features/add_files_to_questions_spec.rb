require 'rails_helper'

feature 'Add files to question' do
  given(:user) { create(:user) }

  background do
    sign_in_with(user.email, user.password)
    visit new_question_path
  end

  scenario 'User adds file to question', js: true do
    fill_in 'Title', with: 'Title'
    fill_in 'Body', with: 'Body'

    attach_file 'File', "#{Rails.root}/spec/support/files/stark.png"
    within '.nested_fields' do
      click_on 'Add attachment'
    end

    within '.fields:not(:first-child)' do
      attach_file 'File', "#{Rails.root}/spec/support/files/facepalm.gif"
    end
    click_on 'Create'

    expect(page).to have_link 'stark.png', href: '/uploads/attachment/file/1/stark.png'
    expect(page).to have_link 'facepalm.gif', href: '/uploads/attachment/file/2/facepalm.gif'
  end
end
