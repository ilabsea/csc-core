# frozen_string_literal: true

module CscCore
  module Samples
    class ScorecardKnowledge < Base
      def self.load
        xlsx = Roo::Spreadsheet.open(file_path("scorecard_knowledges.xlsx"))
        xlsx.each_with_pagename do |_page_name, sheet|
          rows = sheet.parse(headers: true)
          rows[1..-1].each_with_index do |row, _index|
            next unless row["code"].present?

            sk = CscCore::ScorecardKnowledge.find_or_create_by(code: row["code"])
            sk.update(name_en: row["name_en"], name_km: row["name_km"])
          end
        end
      end
    end
  end
end
