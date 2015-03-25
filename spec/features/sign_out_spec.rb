require 'rails_helper'

feature 'User sign out' do
  given(:user) { create(:user) }

  scenario 'User can properly sign out' do
    sign_in_with(user.email, user.password)
    visit root_path

    click_on 'Logout'

    expect(page).to have_content 'Login'
    expect(page).to have_content 'Register'
  end
end
