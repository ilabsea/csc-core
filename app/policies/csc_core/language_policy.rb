# frozen_string_literal: true

module CscCore
  class LanguagePolicy < ApplicationPolicy
    def index?
      user.program_admin? || user.staff? || user.lngo?
    end

    def create?
      user.program_admin?
    end

    def update?
      user.program_admin?
    end

    def destroy?
      user.program_admin?
    end

    class Scope < Scope
      def resolve
        scope.all
      end
    end
  end
end
