# frozen_string_literal: true

# == Schema Information
#
# Table name: chat_groups_notifications
#
#  id              :bigint           not null, primary key
#  chat_group_id   :integer
#  notification_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
module CscCore
  class ChatGroupsNotification < ApplicationRecord
    self.table_name = "chat_groups_notifications"

    belongs_to :notification
    belongs_to :chat_group
  end
end
