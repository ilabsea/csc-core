# frozen_string_literal: true

module CscCore
  module Tagable
    extend ActiveSupport::Concern

    included do
      belongs_to :tag, class_name: 'CscCore::Tag', optional: true

      delegate :name, to: :tag, prefix: :tag, allow_nil: true

      accepts_nested_attributes_for :tag, reject_if: lambda { |attributes|
        attributes["name"].blank?
      }

      def tag_attributes=(attribute)
        self.tag = CscCore::Tag.find_or_create_by(name: attribute[:name].downcase) if attribute[:name].present?
      end
    end
  end
end
