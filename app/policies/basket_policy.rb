# frozen_string_literal: true

class BasketPolicy < ApplicationPolicy
  def show?
    user.admin? || user.id == record.user_id
  end

  def update?
    # We don't want admin to update other users baskets to prevent malicious actions
    user.id == record.user_id
  end

  def add_product?
    user.persisted?
  end

  def destroy?
    # But admin can delete items from baskets if that item is unavailable for some reason
    show?
  end

  class Scope < Scope
    def resolve
      user.admin? ? scope.all : scope.where(user_id: user.id)
    end
  end
end
