# frozen_string_literal: true

module Management
  class MessagePolicy < ApplicationPolicy
    def index?
      user.admin?
    end

    def create?
      true
    end

    def destroy?
      user.admin?
    end

    class Scope < Scope
      def resolve
        user.admin? ? scope.all : scope.none
      end
    end
  end
end
