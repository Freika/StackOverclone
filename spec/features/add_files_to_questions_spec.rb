require 'rails_helper'

feature 'Add files to question' do
  given(:user) { create(:user) }

  background do
    sign_in_with(user.email, user.password)
    visit new_question_path
  end

  scenario 'User adds file to question' do
    fill_in 'Title', with: 'Title'
    fill_in 'Body', with: 'Body'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
  end
end
