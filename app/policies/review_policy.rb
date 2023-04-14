class ReviewPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   if user.admin?
    #     scope.all
    #   else
    #     scope.where(published: true)
    #   end
    # end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    login?
  end

  def new?
    create?
  end

  def update?
    login? && (user.admin? || author?)
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end
