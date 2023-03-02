module FeatureHelpers
  def log_in(user)
    visit new_user_session_path
    fill_in 'Login', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  def log_out
    click_on 'Log out'
  end
end
