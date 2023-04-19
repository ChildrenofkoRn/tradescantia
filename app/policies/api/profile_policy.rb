class Api::ProfilePolicy < Api::BasePolicy

  def me?
    login?
  end

end
