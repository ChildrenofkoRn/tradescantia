require 'rails_helper'

feature 'User can log out', %q(
  I want to log out
) do

  scenario 'Authenticated user tries to log out' do
    log_in(create(:user))

    click_on 'Log out'
    expect(page).to have_content('Signed out successfully.')
  end
end
