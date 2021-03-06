# frozen_string_literal: true

FactoryBot.define do
  factory :language_rating_scale, class: "CscCore::LanguageRatingScale" do
    content { CscCore::RatingScale.defaults.sample[:name] }
    language
    language_code { language.code }
    rating_scale
    audio { Rack::Test::UploadedFile.new(fixture_attachment_path("audio.mp3")) }
  end
end
