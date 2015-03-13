require 'rails_helper'

feature 'User sign in' do

  given(:user) { create(:user) }

  scenario 'Registered user tries to sign in' do
    sign_in_with(user.email, user.password)

    expect(current_path).to eq root_path
  end

  scenario 'Unregistered user tries to sign in' do
    sign_in_with('wrong@email.com', '0001234')

    expect(page).to have_content 'Invalid email or password'
    expect(current_path).to eq new_user_session_path
  end
end
