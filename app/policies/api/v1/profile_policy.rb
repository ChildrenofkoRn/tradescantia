class Api::V1::ProfilePolicy < Api::V1::BasePolicy

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(type: 'User')
      end
    end
  end

  def me?
    login?
  end

  def index?
    login?
  end

end
