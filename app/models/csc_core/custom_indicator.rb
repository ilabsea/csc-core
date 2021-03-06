# frozen_string_literal: true

# == Schema Information
#
# Table name: custom_indicators
#
#  id             :bigint           not null, primary key
#  name           :string
#  audio          :string
#  scorecard_uuid :string
#  tag_id         :integer
#  uuid           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
module CscCore
  class CustomIndicator < ApplicationRecord
    self.table_name = "custom_indicators"

    include Indicatorable
    include Tagable

    mount_uploader :audio, AudioUploader

    belongs_to :scorecard, foreign_key: :scorecard_uuid

    validates :name, presence: true

    before_create :secure_uuid
  end
end
