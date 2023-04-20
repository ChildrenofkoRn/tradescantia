class Api::ProfilePolicy < Api::BasePolicy

  def me?
    login?
  end

  def index?
    login?
  end

end
