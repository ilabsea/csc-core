# frozen_string_literal: true

# == Schema Information
#
# Table name: telegram_bots
#
#  id         :bigint           not null, primary key
#  token      :string
#  username   :string
#  enabled    :boolean          default(FALSE)
#  actived    :boolean          default(FALSE)
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module CscCore
  class TelegramBot < ApplicationRecord
    self.table_name = "telegram_bots"

    belongs_to :program

    validates :token, :username, presence: true, if: :enabled?

    before_create :post_webhook_to_telegram, if: :enabled?
    before_update :post_webhook_to_telegram, if: :enabled?

    def post_webhook_to_telegram
      bot = Telegram::Bot::Client.new(token: token, username: username)

      begin
        request = bot.set_webhook(url: ENV["TELEGRAM_CALLBACK_URL"])

        self.actived = request["ok"]
      rescue StandardError
        self.actived = false
      end
    end
  end
end
