# frozen_string_literal: true

module CscCore
  class DashboardInterpreter < Dashboards::BaseInterpreter
    attr_reader :program, :gf_dashboard

    def initialize(program)
      @program = program
      @gf_dashboard = program.gf_dashboard
    end

    def interpreted_message
      data = load_json_data("dashboard.json")
      assign_uid(data)

      %w[panel variable].each do |model|
        "CscCore::Dashboards::#{model.camelcase}Interpreter".constantize.new(program, data).interpret
      rescue StandardError
        Rails.logger.warn "Model #{model} is unknwon"
      end

      data
    end

    private
      def assign_uid(data)
        data["id"] = nil
        data["uid"] = gf_dashboard.try(:dashboard_uid) || SecureRandom.uuid[1..9]
      end
  end
end
