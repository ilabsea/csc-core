# frozen_string_literal: true

FactoryBot.define do
  factory :scorecard_progress, class: "CscCore::ScorecardProgress" do
    scorecard
    user
  end
end
