# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecards
#
#  id                        :bigint           not null, primary key
#  uuid                      :string
#  unit_type_id              :integer
#  facility_id               :integer
#  name                      :string
#  description               :text
#  province_id               :string(2)
#  district_id               :string(4)
#  commune_id                :string(6)
#  location_code             :string
#  primary_school_code       :string
#  year                      :integer
#  conducted_date            :datetime
#  number_of_caf             :integer
#  number_of_participant     :integer
#  number_of_female          :integer
#  number_of_disability      :integer
#  number_of_ethnic_minority :integer
#  number_of_youth           :integer
#  number_of_id_poor         :integer
#  planned_start_date        :datetime
#  planned_end_date          :datetime
#  status                    :integer
#  program_id                :integer
#  local_ngo_id              :integer
#  scorecard_type            :integer
#  creator_id                :integer
#  locked_at                 :datetime
#  downloaded_count          :integer
#  progress                  :integer
#  language_conducted_code   :string
#  finished_date             :datetime
#  running_date              :datetime
#  deleted_at                :datetime
#  published                 :boolean          default(FALSE)
#  device_type               :string
#  device_token              :string
#  submitted_at              :datetime
#  completed_at              :datetime
#  completor_id              :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  dataset_code              :string
#
module CscCore
  class Scorecard < ApplicationRecord
    self.table_name = "scorecards"

    include Scorecards::Lockable
    include Scorecards::Location
    include Scorecards::Filter
    include Scorecards::CallbackNotification
    include Scorecards::Elasticsearch

    acts_as_paranoid

    enum scorecard_type: {
      self_assessment: 1,
      community_scorecard: 2
    }

    enum progress: ScorecardProgress.statuses

    STATUS_COMPLETED = "completed"
    STATUS_IN_REVIEW = "in_review"
    SCORECARD_TYPES = scorecard_types.keys.map { |key| [I18n.t("scorecard.#{key}"), key] }

    belongs_to :unit_type, class_name: "CscCore::Facility"
    belongs_to :facility
    belongs_to :local_ngo, optional: true
    belongs_to :program
    belongs_to :location, foreign_key: :location_code, optional: true
    belongs_to :creator, class_name: "CscCore::User"
    belongs_to :completor, class_name: "CscCore::User", optional: true
    belongs_to :primary_school, foreign_key: :primary_school_code, optional: true
    belongs_to :dataset, foreign_key: :dataset_code, primary_key: :code, optional: true
    belongs_to :language, foreign_key: :language_conducted_code, primary_key: :code, optional: true

    has_many   :facilitators, foreign_key: :scorecard_uuid
    has_many   :cafs, through: :facilitators
    has_many   :participants, foreign_key: :scorecard_uuid
    has_many   :custom_indicators, foreign_key: :scorecard_uuid
    has_many   :raised_indicators, foreign_key: :scorecard_uuid
    has_many   :voting_indicators, foreign_key: :scorecard_uuid
    has_many   :ratings, foreign_key: :scorecard_uuid
    has_many   :scorecard_progresses, foreign_key: :scorecard_uuid, primary_key: :uuid
    has_many   :suggested_actions, foreign_key: :scorecard_uuid, primary_key: :uuid
    has_many   :scorecard_references, foreign_key: :scorecard_uuid, primary_key: :uuid
    has_many   :request_changes, foreign_key: :scorecard_uuid, primary_key: :uuid

    has_many   :indicator_activities, foreign_key: :scorecard_uuid, primary_key: :uuid
    has_many   :strength_indicator_activities, foreign_key: :scorecard_uuid, primary_key: :uuid
    has_many   :weakness_indicator_activities, foreign_key: :scorecard_uuid, primary_key: :uuid
    has_many   :suggested_indicator_activities, foreign_key: :scorecard_uuid, primary_key: :uuid

    delegate  :name, to: :local_ngo, prefix: :local_ngo, allow_nil: true
    delegate  :name_en, :name_km, :name, to: :primary_school, prefix: :primary_school, allow_nil: true
    delegate  :name_en, :name_km, :name, to: :dataset, prefix: :dataset, allow_nil: true
    delegate  :name, to: :facility, prefix: :facility

    validates :year, presence: true
    validates :province_id, presence: true
    validates :district_id, presence: true
    validates :commune_id, presence: true, if: -> { facility.try(:category_id).nil? || facility.category.hierarchy.include?("commune") }
    validates :unit_type_id, presence: true
    validates :facility_id, presence: true
    validates :scorecard_type, presence: true
    validates :local_ngo_id, presence: true
    validates :dataset_code, presence: true, if: -> { facility.try(:category_id).present? }

    validates :planned_start_date, presence: true
    validates :planned_end_date, presence: true
    validates :planned_end_date, presence: true, date: { after_or_equal_to: :planned_start_date }

    before_create :secure_uuid
    before_create :set_name
    before_create :set_published
    before_save   :clear_primary_school_code, unless: -> { facility.try(:dataset).present? }

    after_commit  :index_document_async, on: %i[create update], if: -> { ENV["ELASTICSEARCH_ENABLED"] == "true" }
    after_destroy :delete_document_async, if: -> { ENV["ELASTICSEARCH_ENABLED"] == "true" }

    accepts_nested_attributes_for :facilitators, allow_destroy: true
    accepts_nested_attributes_for :participants, allow_destroy: true
    accepts_nested_attributes_for :raised_indicators, allow_destroy: true
    accepts_nested_attributes_for :voting_indicators, allow_destroy: true
    accepts_nested_attributes_for :ratings, allow_destroy: true

    scope :completeds, -> { where.not(locked_at: nil) }
    scope :persisteds, -> { where.not(id: nil) }

    def status
      progress.present? ? progress : "planned"
    end

    def completed?
      access_locked?
    end

    def renewed?
      progress == "renewed"
    end

    # Class method
    def self.t_scorecard_types
      scorecard_types.keys.map { |key| [I18n.t("scorecard.#{key}"), key] }
    end

    private
      def secure_uuid
        self.uuid ||= six_digit_rand

        return unless self.class.exists?(uuid: uuid)

        self.uuid = six_digit_rand
        secure_uuid
      end

      def six_digit_rand
        SecureRandom.random_number(1..999_999).to_s.rjust(6, "0")
      end

      def set_name
        self.name = "#{location_code}-#{year}"
      end

      def set_published
        self.published = program.data_publication.present? && !program.data_publication.stop_publish_data?
      end

      def clear_primary_school_code
        self.primary_school_code = nil
      end
  end
end
