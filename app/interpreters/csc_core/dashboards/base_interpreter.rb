# frozen_string_literal: true

module CscCore
  module Dashboards
    class BaseInterpreter
      def gsub_program_id(program, str)
        return str unless str.present?

        str.gsub(/\$\{program_id\}/, program.id.to_s)
      end

      def load_json_data(filename)
        file_path = CscCore::Engine.root.join("public", filename).to_s
        return puts "Fail to import data. could not find #{file_path}" unless File.file?(file_path)

        JSON.load File.open(file_path)
      end
    end
  end
end
