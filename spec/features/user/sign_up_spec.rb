feature 'User can sign up', %q(
  I'd like to be able to sign up
  to create your own content and comment on other users
) do

  background do
    visit root_path
    click_on 'Log in'
    click_on 'Sign up'
  end

  given(:user) { build(:user, :unconfirmed) }

  scenario 'User successfully signs up' do
    fill_in 'Email', with: user.email
    fill_in 'Username', with: user.username
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'
    open_email user.email
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'User unsuccessfully signs up' do
    fill_in 'Email', with: 'user@example.edu'
    fill_in 'Password', with: 'fluency'
    fill_in 'Password confirmation', with: 'goooooo'
    click_on 'Sign up'

    expect(page).to have_css '#error_explanation'
  end
end
