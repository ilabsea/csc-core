# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecard_knowledges
#
#  id         :bigint           not null, primary key
#  code       :string
#  name_en    :string
#  name_km    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module CscCore
  class ScorecardKnowledge < ApplicationRecord
    self.table_name = "scorecard_knowledges"

    has_many :cafs_scorecard_knowledges
    has_many :cafs, through: :cafs_scorecard_knowledges

    validates :code, presence: true
    validates :name_en, presence: true
    validates :name_km, presence: true

    def name
      self["name_#{I18n.locale}"]
    end
  end
end
