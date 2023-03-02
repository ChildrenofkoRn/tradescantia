require 'rails_helper'

feature 'User can log in', %q{
  I'd like to be able to log in
  to create your own content and comment on other users, etc
} do

  given(:user) { create(:user) }

  background do
    visit root_path
    click_on 'Log in'
  end

  def try_login(login, password)
    fill_in 'Login', with: login
    fill_in 'Password', with: password
    click_button 'Log in'
  end

  scenario 'Registered user tries to log in via email' do
    try_login(user.email, user.password)

    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_no_link('Log in')
  end

  scenario 'Registered user tries to log in via username' do
    try_login(user.username, user.password)

    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_no_link('Log in')
  end

  scenario 'Unregistered user tries to log in' do
    try_login('this@email.notfound', '0987654321')

    expect(page).to have_content 'Invalid Login or password.'
  end
end
