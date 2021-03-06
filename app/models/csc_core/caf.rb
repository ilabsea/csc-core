# frozen_string_literal: true

# == Schema Information
#
# Table name: cafs
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  sex                       :string
#  date_of_birth             :string
#  tel                       :string
#  address                   :string
#  local_ngo_id              :integer
#  actived                   :boolean          default(TRUE)
#  educational_background_id :string
#  scorecard_knowledge_id    :string
#  deleted_at                :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
module CscCore
  class Caf < ApplicationRecord
    self.table_name = "cafs"

    belongs_to :local_ngo
    belongs_to :educational_background, optional: true
    has_many :facilitators
    has_many :scorecards, through: :facilitators
    has_many :cafs_scorecard_knowledges
    has_many :scorecard_knowledges, through: :cafs_scorecard_knowledges

    acts_as_paranoid if column_names.include? "deleted_at"

    delegate :name, to: :educational_background, prefix: :educational_background, allow_nil: true

    GENDERS = %w[female male other].freeze

    validates :name, presence: true
    validates :sex, inclusion: { in: GENDERS }, allow_blank: true

    scope :actives, -> { where(actived: true) }

    def self.filter(params)
      scope = all
      if params[:keyword].present?
        scope = scope.where("LOWER(name) LIKE ? OR tel LIKE ?", "%#{params[:keyword].downcase}%",
                            "%#{params[:keyword].downcase}%")
      end
      scope = scope.where(local_ngo_id: params[:local_ngo_id]) if params[:local_ngo_id].present?
      scope
    end
  end
end
