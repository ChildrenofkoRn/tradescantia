class DashboardPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    login? && user.admin?
  end

  def change_type?
    index?
  end
end
