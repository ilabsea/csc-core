# frozen_string_literal: true

module CscCore
  module PdfTemplates
    class ScorecardInterpreter
      def initialize(scorecard)
        @scorecard = scorecard
      end

      def load(field)
        if respond_to?(field.to_sym)
          send(field.to_sym)
        else
          @scorecard.send(field.to_sym)
        end
      end

      def conducted_date
        return "" unless @scorecard.conducted_date.present?

        I18n.l(@scorecard.conducted_date)
      end

      def facilitators
        html = @scorecard.cafs.map { |caf| "<li>#{caf.name}</li>" }.join("")

        "<ol>#{html}</ol>"
      end

      def scorecard_type
        I18n.t("interpreter.pdf_template.#{@scorecard.scorecard_type}")
      end
    end
  end
end
