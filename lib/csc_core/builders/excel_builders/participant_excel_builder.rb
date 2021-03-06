# frozen_string_literal: true

module CscCore
  module ExcelBuilders
    class ParticipantExcelBuilder
      attr_accessor :sheet

      def initialize(sheet, scorecards)
        @sheet = sheet
        @scorecards = scorecards
      end

      def build
        build_header

        @scorecards.includes(:participants).each do |scorecard|
          build_row(scorecard)
        end
      end

      def build_header
        sheet.add_row [
          I18n.t("excel.participant_id"),
          I18n.t("excel.scorecard_id"),
          I18n.t("excel.age"),
          I18n.t("excel.gender"),
          I18n.t("excel.youth"),
          I18n.t("excel.disability"),
          I18n.t("excel.id_poor"),
          I18n.t("excel.minority")
        ]
      end

      def build_row(scorecard)
        scorecard.participants.each do |participant|
          sheet.add_row generate_row(participant, scorecard)
        end
      end

      private
        def generate_row(participant, scorecard)
          [
            participant.uuid,
            scorecard.uuid,
            participant.age,
            participant.gender,
            participant.profiles.select { |profile| profile.code == "YO" }.present?,
            participant.profiles.select { |profile| profile.code == "DI" }.present?,
            participant.profiles.select { |profile| profile.code == "PO" }.present?,
            participant.profiles.select { |profile| profile.code == "ET" }.present?,
          ]
        end
    end
  end
end
