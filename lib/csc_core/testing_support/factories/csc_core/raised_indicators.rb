# frozen_string_literal: true

FactoryBot.define do
  factory :raised_indicator, class: "CscCore::RaisedIndicator" do
    # tag
    indicatorable { create(:indicator) }
  end
end
