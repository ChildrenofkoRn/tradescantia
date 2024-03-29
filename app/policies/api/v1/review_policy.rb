class Api::V1::ReviewPolicy < Api::V1::BasePolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def show?
    login?
  end

  def update?
    login? && (user.admin? || author?)
  end
end
