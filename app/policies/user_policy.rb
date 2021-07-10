# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    user.admin? || user == record
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      user.admin? ? scope.all : scope.where(id: user.id)
    end
  end
end