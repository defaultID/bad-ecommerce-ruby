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

  def update_locked?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def show_basket?
    update?
  end

  def show_details?
    update?
  end

  def show_picture?
    true
  end

  def order?
    user == record
  end

  class Scope < Scope
    def resolve
      user.admin? ? scope.all : scope.where(id: user.id)
    end
  end
end
