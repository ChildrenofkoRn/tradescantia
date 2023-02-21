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

  scenario 'Registered user tries to log in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_no_link('Log in')
  end

  scenario 'Unregistered user tries to log in' do
    fill_in 'Email', with: 'this@email.notfound'
    fill_in 'Password', with: '0987654321'
    click_button 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
