# frozen_string_literal: true

class OrderPolicy < ApplicationPolicy
  def show?
    user.admin? || user.id == record.user_id
  end

  def create?
    user.persisted?
  end

  def pay?
    user.id == record.user_id && %w[new pending].include?(record.status)
  end

  def confirm_payment?
    user.id == record.user_id && record.pending_status?
  end

  def confirm?
    user.id == record.user_id
  end

  def confirm_shipment?
    user.admin? && record.confirmed_status?
  end

  def confirm_receipt?
    user.id == record.user_id && record.shipped_status?
  end

  def destroy?
    (user.admin? || user.id == record.user_id) && record.expired?
  end

  class Scope < Scope
    def resolve
      user.admin? ? scope.all : scope.where(user_id: user.id)
    end
  end
end
