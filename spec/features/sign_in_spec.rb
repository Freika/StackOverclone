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

  scenario 'and sign out' do
    sign_in_with(user.email, user.password)
    visit root_path

    click_on 'Logout'

    expect(page).to have_content 'Login'
    expect(page).to have_content 'Register'
  end

  scenario 'User registration' do
    visit new_user_registration_path

    fill_in 'Email', with: 'some@user.com'
    fill_in 'Password', with: '00000000'
    fill_in 'Password confirmation', with: '00000000'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User authenticated after registration' do
    visit new_user_registration_path

    fill_in 'Email', with: 'some@user.com'
    fill_in 'Password', with: '00000000'
    fill_in 'Password confirmation', with: '00000000'
    click_on 'Sign up'

    visit new_user_session_path

    expect(current_path).to eq root_path
  end
end
