# frozen_string_literal: true

# == Schema Information
#
# Table name: request_changes
#
#  id                  :uuid             not null, primary key
#  scorecard_uuid      :string
#  proposer_id         :integer
#  reviewer_id         :integer
#  year                :string
#  scorecard_type      :integer
#  province_id         :string
#  district_id         :string
#  commune_id          :string
#  primary_school_code :string
#  changed_reason      :text
#  rejected_reason     :text
#  status              :integer
#  resolved_date       :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
module CscCore
  class RequestChange < ApplicationRecord
    self.table_name = "request_changes"

    include ::CscCore::RequestChanges::CallbackNotification

    enum scorecard_type: Scorecard.scorecard_types
    enum status: {
      rejected: 0,
      approved: 1,
      submitted: 2
    }

    belongs_to :scorecard, primary_key: "uuid", foreign_key: "scorecard_uuid"
    belongs_to :proposer, class_name: "User"
    belongs_to :reviewer, class_name: "User", optional: true
    belongs_to :primary_school, foreign_key: :primary_school_code, optional: true

    validates :changed_reason, presence: true
    validates :reviewer, presence: true, if: -> { approved? || rejected? }
    validates :resolved_date, presence: true, if: -> { approved? || rejected? }
    validates :rejected_reason, presence: true, if: -> { rejected? }

    validates :district_id, presence: true, if: -> { province_id.present? }
    validates :commune_id, presence: true, if: -> { province_id.present? }
    validates :primary_school_code, presence: true, if: lambda {
                                                          province_id.present? && scorecard.facility.dataset.present?
                                                        }

    before_validation :set_resolved_date, if: -> { approved? || rejected? }
    before_create :set_status
    after_save :update_scorecard, if: -> { approved? }

    default_scope { order(created_at: :desc) }
    scope :submitteds, -> { where(status: "submitted") }

    def location_name(_address = "address_km")
      return if commune_id.blank?

      "Pumi::#{Location.location_kind(commune_id).titlecase}".constantize.find_by_id(commune_id).try("address_#{I18n.locale}".to_sym)
    end

    private
      def update_scorecard
        scorecard.update(scorecard_param)
      end

      def scorecard_param
        params = {}
        params[:year] = year if year.present? && scorecard.year != year
        if scorecard_type.present? && scorecard.scorecard_type != scorecard_type
          params[:scorecard_type] =
            scorecard_type
        end
        params[:province_id] = province_id if province_id.present? && scorecard.province_id != province_id
        params[:district_id] = district_id if district_id.present? && scorecard.district_id != district_id
        params[:commune_id] = commune_id if commune_id.present? && scorecard.commune_id != commune_id
        if primary_school_code.present? && scorecard.primary_school_code != primary_school_code
          params[:primary_school_code] =
            primary_school_code
        end
        params
      end

      def set_status
        self.status = :submitted
      end

      def set_resolved_date
        self.resolved_date = Time.now
      end
  end
end
