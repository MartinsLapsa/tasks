class TaskPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.author == user || record.responsible == user
  end

  def update?
    author?
  end

  def start?
    responsible?
  end

  def cancel?
    responsible?
  end

  def finish?
    responsible?
  end

  def destroy?
    author?
  end

  private

  def author?
    record.author == user
  end

  def responsible?
    record.responsible == user
  end

  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope.where(author: user).or(scope.where(responsible: user))
    end

    private

    attr_reader :user, :scope
  end
end
