# frozen_string_literal: true

require "rails_helper"

module CscCore
  RSpec.describe RequestChanges::CallbackNotification, type: :model do
    describe "#submitted, send notification" do
      it { expect { create(:request_change) }.to change(RequestChangeWorker.jobs, :size).by(1) }
    end

    describe "#after_save, send notification" do
      let!(:request_change) { create(:request_change) }
      let!(:reviewer) { create(:user) }

      context "approved" do
        it {
          expect do
            request_change.update(status: :approved, reviewer: reviewer)
          end.to change(RequestChangeWorker.jobs, :size).by(1)
        }
      end

      context "rejected" do
        it {
          expect do
            request_change.update(status: :rejected, reviewer: reviewer, rejected_reason: "I reject it")
          end.to change(RequestChangeWorker.jobs, :size).by(1)
        }
      end
    end
  end
end
