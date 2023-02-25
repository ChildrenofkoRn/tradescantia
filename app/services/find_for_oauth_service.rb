class FindForOauthService
  def self.call(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    if auth.try(:info).try(:email).blank?
      return User.new
    else
      downcased_email = auth.info.email.downcase
      user = User.find_by(email: downcased_email)
    end

    User.transaction do
      unless user
        password = Devise.friendly_token[0, 20]
        username = get_username(auth)
        user = User.create!(username: username, email: downcased_email,
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
    if auth.info.try(:nickname).present?
      auth.info.nickname
    else
      auth.info.email.split('@').first.tr('.+', '_')
    end
  end
end
