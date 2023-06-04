require 'rails_helper'

feature 'User can sign in with OAuth providers', %q{
  To create and comment on content
  As an unauthenticated user
  I'd like to be able to sign in through OAuth providers
} do

  given(:user_email) { "github_user@email.space" }
  background { visit new_user_session_path }

  scenario 'User tries to sign up with oauth Github' do
    mock_auth_hash(provider: 'github', email: user_email)

    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from Github account.'
  end

  scenario 'User tries to sign in with oauth Github' do
    create(:user, email: user_email)
    mock_auth_hash(provider: 'github', email: user_email)

    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from Github account.'
  end

end
