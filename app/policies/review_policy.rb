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
    login?
  end

  def new?
    create?
  end

  def update?
    login? && (user&.admin? || author?)
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def ranking?
    login? && !author? && !user.ranked?(record)
  end

  private

  def author?
    user&.author_of?(record)
  end

  def login?
    user.present?
  end
end
