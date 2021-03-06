# frozen_string_literal: true

module CscCore
  module Messages
    class ScorecardInterpreter
      attr_accessor :scorecard

      def initialize(scorecard)
        @scorecard = scorecard
      end

      def load(field)
        if respond_to?(field.to_sym)
          send(field.to_sym)
        else
          return nil unless scorecard.respond_to?(field.to_sym)
          return render_date(field) if Scorecard.columns_hash[field].try(:type) == :datetime

          scorecard.send(field.to_sym)
        end
      end

      def code
        scorecard.uuid
      end

      def url
        link = "#{ENV['HOST_URL']}/scorecards/#{scorecard.id}"
        "<a href='#{link}'>#{link}</a>"
      end

      def facility
        "#{scorecard.unit_type.name} > #{scorecard.facility_name}"
      end

      def scorecard_type
        I18n.t("interpreter.pdf_templates.#{scorecard.scorecard_type}")
      end

      private
        def render_date(field)
          date = scorecard.send(field.to_sym)

          date.present? ? I18n.l(date, format: :nice) : nil
        end
    end
  end
end
