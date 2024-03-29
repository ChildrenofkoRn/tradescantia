require 'rails_helper'

feature 'User can log out', %q(
  I want to log out
) do

  given(:user) { create(:user) }

  scenario 'Authenticated user tries to log out', js: true do
    log_in(user)

    find('#headUserMenu').click
    click_on 'Log out'
    expect(page).to have_content('Signed out successfully.')
  end
end
