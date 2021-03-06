# frozen_string_literal: true

module CscCore
  module Messages
    class FacilitatorInterpreter
      def initialize(scorecard)
        @scorecard = scorecard
      end

      def load(_field)
        return "" if @scorecard.facilitators.first.nil?

        @scorecard.facilitators.first.caf.name
      end
    end
  end
end
