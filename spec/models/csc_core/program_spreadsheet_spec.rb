# frozen_string_literal: true

require "rails_helper"

module CscCore
  RSpec.describe ProgramSpreadsheet do
    describe "#import" do
      let(:program) { create(:program) }
      let(:file) { Rack::Test::UploadedFile.new(fixture_attachment_path("local_ngo_and_caf.xlsx")) }
      let(:program_spreadsheet) { ProgramSpreadsheet.new(program.id) }

      it "receives import method for LocalNgoSpreadsheet" do
        expect_any_instance_of(Spreadsheets::LocalNgoSpreadsheet).to receive(:import).with(instance_of(Roo::Excelx))

        program_spreadsheet.import(file)
      end

      it "receives import method for CafSpreadsheet" do
        expect_any_instance_of(Spreadsheets::CafSpreadsheet).to receive(:import).with(instance_of(Roo::Excelx))

        program_spreadsheet.import(file)
      end

      context "no file" do
        it "returns nil" do
          expect(program_spreadsheet.import(nil)).to be_nil
        end
      end

      context "wrong file extension" do
        let(:wrong_file) { Rack::Test::UploadedFile.new(fixture_image_path("reference_image.png")) }

        it "returns nil" do
          expect(program_spreadsheet.import(wrong_file)).to be_nil
        end
      end
    end
  end
end
