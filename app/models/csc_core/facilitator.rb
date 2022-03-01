# frozen_string_literal: true

# == Schema Information
#
# Table name: facilitators
#
#  id             :bigint           not null, primary key
#  caf_id         :integer
#  scorecard_uuid :integer
#  position       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
module CscCore
  class Facilitator < ApplicationRecord
    self.table_name = "facilitators"

    belongs_to :scorecard, foreign_key: :scorecard_uuid, optional: true
    belongs_to :caf, -> { with_deleted }
  end
end
