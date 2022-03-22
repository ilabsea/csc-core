# frozen_string_literal: true

module CscCore
  module Categorizable
    extend ActiveSupport::Concern

    included do
      has_many :indicators, as: :categorizable, dependent: :destroy

      accepts_nested_attributes_for :indicators, allow_destroy: true, reject_if: lambda { |attributes|
        attributes["name"].blank?
      }
    end
  end
end
