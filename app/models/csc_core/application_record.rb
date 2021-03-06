# frozen_string_literal: true

module CscCore
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    strip_attributes

    private
      def secure_uuid
        self.uuid ||= SecureRandom.uuid

        return unless self.class.exists?(uuid: uuid)

        self.uuid = SecureRandom.uuid
        secure_uuid
      end
  end
end
