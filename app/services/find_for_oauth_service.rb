class FindForOauthService
  #REFACTOR
  def self.call(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    if auth.try(:info).try(:email).blank?
      # TODO if Oauth Provider doesnt return e-mail
      # For example, add redirect from create_auth to an action with a form in OauthCallbacksController
      # and session['omniauth.auth'] = request.env['omniauth.auth']
      return User.new
    else
      email = auth.info.email
      user = User.find_by("lower(email) = ?", email.downcase)
    end

    User.transaction do
      unless user
        password = Devise.friendly_token[0, 20]
        username = get_username(auth)
        user = User.create!(username: username, email: email,
                            password: password, password_confirmation: password)
      end

      user.authorizations.create!(provider: auth.provider, uid: auth.uid.to_s)
    end

    user
  end

  private

  def self.get_username(auth)
    return auth.uid if auth.try(:info).blank?

    # auth.info.name returns any of the available values: name, first_name, nickname, email
    # https://github.com/omniauth/omniauth/blob/7d90ba21c26299df8001684cbfbb6c54ce8ea440/lib/omniauth/auth_hash.rb#L32
    username = if auth.info.try(:nickname).present?
                auth.info.nickname
               else
                auth.info.email.split('@').first.tr('.+', '_')
               end

    #TODO better to prompt the user for username or redirect to edit_user_registration_path after registration
    make_username_unique(username, auth.uid)
  end

  def self.make_username_unique(username, uid)
    User.exists?(username: username) ? "#{username}_#{uid}" : username
  end
end
