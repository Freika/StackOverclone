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
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Add answer'

    within '.answers' do
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
  end
end
