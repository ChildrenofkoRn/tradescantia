class ReviewPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    user&.admin? || author?
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def ranking?
    user && !author?
  end

  private

  def author?
    user == record.author
  end
end
